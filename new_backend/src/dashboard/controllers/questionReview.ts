import { Request, Response, NextFunction } from 'express';
import QuestionReview, { IQuestionReview } from '../models/questionReview';
import { questionReviewValidation } from '../../validations/joiModelValidator';
import { BaseResponse } from '../../types/baseResponse';
import Question, { IQuestion } from '../../models/question';
import Reviewer from '../models/reviewer';
import Admin from '../models/admin';
import QuestionFlag from '../../models/questionFlag';

const createQuestionReview = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { questionId, reviewerId, comment, status, requestedBy } = req.body;
  
      // Validate questionId
      const isValidQuestion = await Question.findById(questionId).lean().exec();
      if (!isValidQuestion) {
        throw new Error('Invalid questionId.');
      }
  
      // Validate reviewerId
      const isValidReviewer = await Reviewer.findById(reviewerId).lean().exec();
      if (!isValidReviewer) {
        throw new Error('Invalid reviewerId.');
      }
  
      // Validate requestedBy
      const isValidAdmin = await Admin.findById(requestedBy).lean().exec();
      if (!isValidAdmin) {
        throw new Error('Invalid requestedBy.');
      }
  
      const userInput = { questionId, reviewerId, comment, status, requestedBy };
  
      const { error, value } = questionReviewValidation(userInput, 'post');
  
      if (error) throw error;
  
      const questionReview = new QuestionReview({ ...value });
  
      const savedQuestionReview = await questionReview.save();
  
      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Question review created successfully!';
      baseResponse.data = {
        newQuestionReview: savedQuestionReview,
      };
  
      return res.status(201).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
};

const getQuestionReviews = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const questionReviews = await QuestionReview.find().lean().exec();
    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Question reviews retrieved successfully!';
    baseResponse.data = {
      questionReviews,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getQuestionReview = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const id = req.params.id;
    const questionReview = await QuestionReview.findById(id).lean().exec();

    if (!questionReview) throw Error('Question review not found with that Id.');

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Question review retrieved successfully!';
    baseResponse.data = {
      questionReview,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const updateQuestionReview = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const role = req.body.dashboardUser.role;
    const userId = req.body.userDetails._id.toString();
    if (role !== "REVIEWER"){
      throw Error("user is not a reviewer")
    }
    const questionReviewToBeUpdated = await QuestionReview.findById(id).lean().exec();
    if (!questionReviewToBeUpdated) throw Error('Question review not found with that Id.');

    if (userId.toString() !== questionReviewToBeUpdated.reviewerId.toString()){
      throw Error('user not assingd to mock')
    }

    const {  comment, status } = req.body;

    let updateObject = { comment, status };

    for (const key in updateObject) {
      if (!updateObject[key]) delete updateObject[key];
    }


    const { error, value } = questionReviewValidation(updateObject, 'put');

    if (error) throw error;

    const updatedQuestionReview = await QuestionReview.findByIdAndUpdate(id, value, { new: true }).lean().exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Question review updated successfully!';
    baseResponse.data = {
      updatedQuestionReview,
    };
    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const deleteQuestionReview = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const questionReviewToBeDeleted = await QuestionReview.findById(id).lean().exec();

    if (!questionReviewToBeDeleted) throw Error('Question review not found with that Id.');

    const deletedQuestionReview = await QuestionReview.findByIdAndDelete(id).lean().exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Question review deleted successfully!';
    baseResponse.data = {
      deletedQuestionReview,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getQuestionDetails = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const questionId = req.params.id;
    const role = req.body.dashboardUser.role;
    const userId = req.body.userDetails._id.toString();

    // Fetch data from the questions table
    const question = await Question.findById(questionId)
      .select('-isForQuiz -chapterId -courseId -subChapterId -isForMock -departmentId -relatedTopic -__v')
      .lean()
      .exec();
    if (!question) throw Error('Question not found with that Id.');

    let baseResponse = new BaseResponse();

    if (role === 'REVIEWER') {
      // Fetch the latest questionReview for the specific reviewer based on updatedAt
      const questionReview = await QuestionReview.findOne({ questionId, reviewerId: userId })
        .sort({ updatedAt: -1 }) // Sort in descending order based on updatedAt
        .select('-questionId -requestedBy -__v')
        .lean()
        .exec();

      if (!questionReview) {
        throw Error('Question not assigned to the reviewer.');
      }

      baseResponse.success = true;
      baseResponse.message = 'Question details retrieved successfully!';
      baseResponse.data = {
        question,
        questionReviews: [questionReview],
      };
    } else if (role === 'ADMIN' || role === 'SUPER_ADMIN' || role === "REVIEWER_ADMIN") {
      const questionReviews = await QuestionReview.find({ questionId })
        .populate('reviewerId')
        .select('-questionId -requestedBy -__v')
        .lean()
        .exec();

      const questionFlags = await QuestionFlag.find({ questionId })
        .populate({
          path: 'userId',
          select: 'firstName lastName',
          populate: { path: 'avatar', select: 'imageAddress cloudinaryId -_id' },
        })
        .select('-questionId -__v')
        .lean()
        .exec();

      baseResponse.success = true;
      baseResponse.message = 'Question details retrieved successfully!';
      baseResponse.data = {
        question,
        questionReviews,
        questionFlags,
      };
    } else {
      throw new Error('Invalid user role');
    }

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};


const updateQuestion = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const questionId = req.params.id; 
    const updates: Partial<IQuestion> = req.body; 

    // Fetch the question from the database
    const question = await Question.findById(questionId);
    

    if (!question) {
      throw Error('Invalid question Id')
    }

    const previousQuestion= question
    Object.keys(updates).forEach((key) => {
      const value = updates[key];
      if (value !== undefined && value !== null && value !== '' && key !== '_id') {
        question[key] = value;
      }
    });

    const updatedQuestion= (await question.save());

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Question updated successfully!';
    baseResponse.data = {
      updatedQuestion,
      previousQuestion
    };
    return res.status(200).json(baseResponse);
  } catch (error) {
    next(error);
  }
};

const questionReviewControllers = {
  createQuestionReview,
  getQuestionReviews,
  getQuestionReview,
  updateQuestionReview,
  deleteQuestionReview,
  getQuestionDetails,
  updateQuestion
};

export default questionReviewControllers;
