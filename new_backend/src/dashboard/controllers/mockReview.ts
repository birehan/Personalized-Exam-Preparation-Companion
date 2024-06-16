import { Request, Response, NextFunction } from 'express';
import MockReview, { IMockReviewDocument } from '../models/mockReview';
import { mockReviewValidation, questionValidator } from '../../validations/joiModelValidator';
import { BaseResponse } from '../../types/baseResponse';
import Mock from '../../models/mock';
import Reviewer from '../models/reviewer';
import QuestionReview, { IQuestionReview } from '../models/questionReview';
import Question from '../../models/question';
import { Types } from 'mongoose';
import { isExistingReviewer } from '../../services/helpers';

const createMockReview = async (req: Request, res: Response, next: NextFunction) => {
  try {
    // requestedBy should be taken from the auth middleware: it should be authorized that the user should be Admin

    const { mockId, reviewerId, requestedBy } = req.body;

    const userInput = { mockId, reviewerId, requestedBy };

    const { error, value } = mockReviewValidation(userInput, 'post');

    if (error) throw error;

    const foundMock = await Mock.findOne({ _id: mockId }).lean().exec();

    if (!foundMock) {
      throw Error('Mock not found!');
    }

    const foundReviewer = await Reviewer.findOne({ _id: reviewerId }).lean().exec();

    if (!foundReviewer) {
      throw Error('Reviewer not found with that ID');
    }

    const mockReview = new MockReview({ ...value });

    const savedMockReview = await mockReview.save();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Mock review created successfully!';
    baseResponse.data = {
      newMockReview: savedMockReview,
    };

    return res.status(201).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getMockReviews = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const mockReviews = await MockReview.aggregate([
      {
        $lookup: {
          from: 'mocks',
          localField: 'mockId',
          foreignField: '_id',
          as: 'mock',
        },
      },
      {
        $lookup: {
          from: 'reviewers',
          localField: 'reviewerId',
          foreignField: '_id',
          as: 'reviewer',
        },
      },
      {
        $unwind: '$mock',
      },
      {
        $unwind: '$reviewer',
      },
      {
        $project: {
          _id: '$_id',
          mockId: '$mock._id',
          name: '$mock.name',
          isStandard: '$mock.isStandard',
          subject: '$mock.subject',
          examYear: '$mock.examYear',
          reviewerId: '$reviewer._id',
          reviewerName: { $concat: ['$reviewer.firstName', ' ', '$reviewer.lastName'] },
          status: '$status',
          createdAt: '$createdAt',
          updatedAt: '$updatedAt'
        },
      },
    ]).exec();

    const baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Mock reviews retrieved successfully!';
    baseResponse.data = {
      mockReviews,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getMockReview = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const id = req.params.id;
    const mockReview = await MockReview.findOne({ _id: id }).lean().exec();

    if (!mockReview) throw Error('Mock review not found with that Id.');

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Mock review retrieved successfully!';
    baseResponse.data = {
      mockReview,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const updateMockReview = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const mockReviewToBeUpdated = await MockReview.findById(id).lean().exec();

    if (!mockReviewToBeUpdated) throw Error('Mock review not found with that Id.');

    const { status } = req.body;

    let updateObject = { status };

    for (const key in updateObject) {
      if (!updateObject[key]) delete updateObject[key];
    }

    const { error, value } = mockReviewValidation(updateObject, 'put');

    if (error) throw error;

    // Check if all associated QuestionReviews are approved
    const allQuestionReviewsApproved = await QuestionReview.find({
      mockReviewId: id,
      status: { $ne: 'approved' },
    }).countDocuments() === 0;

    if (allQuestionReviewsApproved) {
      const updatedMockReview = await MockReview.findByIdAndUpdate(id, value, { new: true })
        .lean()
        .exec();

      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Mock review updated successfully!';
      baseResponse.data = {
        updatedMockReview,
      };
      return res.status(200).json({ ...baseResponse });
    } else {
      throw Error(`You haven't reviewed and approved all the questions!`)
    }
  } catch (error) {
    next(error);
  }
};

const deleteMockReview = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const mockReviewToBeDeleted = await MockReview.findById(id).lean().exec();

    if (!mockReviewToBeDeleted) throw Error('Mock review not found with that Id.');

    const deletedMockReview = await MockReview.findByIdAndDelete(id).lean().exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Mock review deleted successfully!';
    baseResponse.data = {
      deletedMockReview,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const assignMockToReviewer = async (req: Request, res: Response, next: NextFunction) => {
    try {

    const { mockId, reviewerId } = req.body;
    const requestedBy = req.body.userDetails._id.toString();

    const userInput = { mockId, reviewerId, requestedBy };

      const { error, value } = mockReviewValidation(userInput, 'post');
      if (error) throw error;

      const foundReviewer = await isExistingReviewer(reviewerId);

      if(!foundReviewer){
        throw new Error("Reviewer not found with that Id or is inActive!");
      }
  
      const existingAssignment: IMockReviewDocument | null = await MockReview.findOne({
        reviewerId,
        mockId,
        status: 'pending',
      });
      let baseResponse = new BaseResponse();

  
      if (existingAssignment) {
        baseResponse.success = true;
        baseResponse.message = 'Already assigned reviewer!';
        baseResponse.data = {
          newMockReview: existingAssignment,
        };
  
      return res.status(201).json({ ...baseResponse });
      }
  
      const foundMock = await Mock.findOne({ _id: mockId }).lean().exec();
      if (!foundMock) {
        throw Error('Mock not found with that ID.');
      }
  
      const mockReview = new MockReview({ ...value });
      const savedMockReview = await mockReview.save();
  
      const questionReviews: IQuestionReview[] = [];
      for (const questionId of foundMock.questions) {
        const questionReview = new QuestionReview({
          questionId,
          reviewerId,
          status: 'pending',
          requestedBy,
          mockReviewId: savedMockReview._id,
        });
        const savedQuestionReview = await questionReview.save();
        questionReviews.push(savedQuestionReview);
      }
  
      baseResponse.success = true;
      baseResponse.message = 'Mock assigned to reviewer and Question Reviews created successfully!';
      baseResponse.data = {
        newMockReview: savedMockReview,
      };
  
      return res.status(201).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };

const getMockQuestionsWithStatus = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { id } = req.params;
      const role = req.body.dashboardUser.role; 
      const userId = req.body.userDetails._id.toString(); 
  
      const mock = await Mock.findById(id).lean().exec();
  
      if (!mock) {
        throw new Error(`Mock not found with ID ${id}`);
      }

      const questionIds = mock.questions.map((questionId) => questionId.toString());
  
      let questionsWithStatus: Array<{ questionId: string; status: string }> = [];
      
      if (role === 'REVIEWER') {
          
          const questionReview: IQuestionReview | null = await QuestionReview.findOne({
            questionId: questionIds[0],
            reviewerId: userId,
          })
            .sort({ updatedAt: -1 })
            .lean();
    
          if (!questionReview) {
            throw Error('not assigned mock')
          }
    
          const mockReview: IMockReviewDocument | null = await MockReview.findById(
            questionReview.mockReviewId
          ).lean();
    
          if (!mockReview || mockReview.status != "pending") {
            throw Error('Not assigned question')
          }
    
        const questionReviews = await QuestionReview.aggregate([
          {
            $match: {
              questionId: { $in: questionIds.map(id =>  new Types.ObjectId(id)) },
              reviewerId: new Types.ObjectId(userId),
              mockReviewId: new Types.ObjectId(mockReview._id)
            },
          },
          {
            $sort: { createdAt: -1 },
          },
        ]);

        if (questionReviews.length === 0){
          throw Error("This mock is not assigned to the reviewer!")
        }
  
        questionsWithStatus = questionReviews.map((review) => ({
          questionId: review.questionId.toString(),
          reviewId: review._id,
          status: review.status,
        }));
      }
      else if (role === 'ADMIN' || role === 'SUPER_ADMIN' || role === 'REVIEWER_ADMIN') {
        const questions = await Question.find({ _id: { $in: questionIds } })
          .select('_id adminApproval')
          .lean()
          .exec();
  
        questionsWithStatus = questions.map((question) => ({
          questionId: question._id.toString(),
          status: question.adminApproval ? 'approved' : 'pending',
        }));
      }  else {
        throw new Error('Invalid user role');
      }
  
      return res.status(200).json({
        success: true,
        message: 'Mock questions with status retrieved successfully!',
        data: {
          mock: {name: mock.name, subject: mock.subject, isStandard: mock.isStandard, examYear: mock.examYear},
          questions: questionsWithStatus
        },
      });
    } catch (error) {
      next(error);
    }
};

const updateMockAdminApproval = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const mockId = req.params.id;
  
      const mock = await Mock.findById(mockId);
  
      if (!mock) {
        throw Error('Invalid mock Id');
      }

      const questions = await Question.find({ _id: { $in: mock.questions } });

      const allApproved = questions.every((question) => question.adminApproval && question.adminApproval === true );
  
      if (allApproved) {
        mock.adminApproval = true;
  
        // Save the updated mock
        await mock.save();
  
        const baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'Mock approved successfully!';
        baseResponse.data = {
          updatedMock: {name: mock.name, adminApproval: mock.adminApproval, isStandard: mock.isStandard, subject: mock.subject, examYear: mock.examYear},
        };
  
        return res.status(200).json(baseResponse);
      } else {
        mock.adminApproval = false;

        await mock.save();
        
       throw Error('Not all questions are approved. please approve all questions.');
      }
    } catch (error) {
      next(error);
    }
};
  
const addQuestionToMock = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const {
      description, choiceA, choiceB, choiceC, choiceD,
      answer, explanation, relatedTopic, isForQuiz,adminApproval,
      chapterId, courseId, subChapterId, mockId
    } = req.body;

    const userInput = { description, choiceA, choiceB, choiceC, choiceD,
      answer, explanation, relatedTopic, isForQuiz, chapterId, courseId, subChapterId, adminApproval };

    const { error, value } = questionValidator(userInput, "post");

    if (error) throw error;

    const question = new Question(value);
    await question.save();

    const mock = await Mock.findById(mockId);

    if (!mock) {
      throw new Error('Mock not found');
    }

    mock.questions.push(question._id);
    await mock.save();

    return res.status(200).json({
      success: true,
      message: 'Question added to mock successfully',
      data: { question },
    })
  } catch (error) {
    next(error);
  }
};

const mockReviewControllers = {
  createMockReview,
  getMockReviews,
  getMockReview,
  updateMockReview,
  deleteMockReview,
  assignMockToReviewer,
  getMockQuestionsWithStatus,
  updateMockAdminApproval,
  addQuestionToMock
};

export default mockReviewControllers;






