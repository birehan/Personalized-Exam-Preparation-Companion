import { Request, Response, NextFunction } from 'express';
import Mock from '../models/mock';
import { mockValidator } from '../validations/joiModelValidator';
import { BaseResponse } from '../types/baseResponse';
import QuestionUserAnswer, { QuestionAnswers } from '../models/questionUserAnswer';
import Course from '../models/course';
import Question from '../models/question';
import Department from '../models/department';
import { isValidObjectId, shuffleArray, strToBool } from '../services/helpers';
import UserQuestionVote from '../models/userQuestionVote';
import { ObjectId } from "mongodb"
import TelegramQuestion from '../models/telegramQuestions';
import TelegramMock from '../models/telegramMock';

//The following doesn't work for Entrance exams!!! TODO: should be updated to work for entrance exam
const createMock = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { name, departmentId } = req.body;

    const userInput = { name, departmentId};
    const { error, value } = mockValidator({...userInput, questions:["64943ec6f296abbe4531d069"] }, "post");

    if (error) throw error

    const foundDepartment = await Department.findById(departmentId).lean().exec();

    if(!foundDepartment) throw Error("No Department found by this Id.");

    const foundMock = await Mock.find({departmentId,}).lean().exec();

    if (foundMock.length === 3) throw Error("You have already created 3 mocks for this department.")

    const courses = await Course.find({ departmentId }).lean().exec();

    const allQuestionsPromises = courses.map(async (course: any) => {
      const courseId = course._id;
      const courseQuestions = await Question.find({
        courseId,
        isForQuiz: true,
        isForMock: false
      })
        .select("_id")
        .lean()
        .exec();
      return courseQuestions;
    });

    const allQuestions = await Promise.all(allQuestionsPromises);
    const flattenedQuestions = allQuestions.flat().map((question: any) => question._id);

    const shuffledQuestions = shuffleArray(flattenedQuestions);
    const selectedQuestions = shuffledQuestions.slice(0, 100);

    const mock = new Mock({ ...userInput, questions: selectedQuestions });

    const savedMock = await mock.save();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = "Mock created successfully!";
    baseResponse.data = {
      newQuestion: savedMock,
    };

    return res.status(201).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

//TODO: userInput should have subject attribute: which is of string value TODO: update mock model to have subject attribute and update this
const createStandardMock = async (req: Request, res: Response, next: NextFunction) => {
  try {
      const { name, subject, examYear, isStandard, questions, departmentId } = req.body;

      const userInput = { name, subject, examYear, isStandard, questions, departmentId}

      const { error, value } = mockValidator(userInput,"post");

      if (error) throw error

      const foundDepartment = await Department.findById(departmentId).lean().exec();

      if(!foundDepartment) throw Error("No Department found by this Id.");

      const foundQuestions = await TelegramQuestion.find({ _id: { $in: questions } });
  
      const invalidQuestionIds = questions.filter((id) => !foundQuestions.some((question) => question._id.equals(id)));
      if (invalidQuestionIds.length > 0) {
        throw Error("No questions found for the following IDs: " + invalidQuestionIds.join(", "));
      }

      const standardMock = new TelegramMock({...value});

      const savedStandardMock = await standardMock.save();

      let baseResponse = new BaseResponse();
      baseResponse.success = true
      baseResponse.message = 'Standard Mock created successfully!'
      baseResponse.data = {
      newStandardMock: savedStandardMock
      }

      return res.status(201).json({...baseResponse})
  } catch (error) {
      next(error)
  };
}


const getMocks = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const mocks = await TelegramMock.find().lean().exec();

    let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Mocks retrieved successfully!'
        baseResponse.data = {
        mocks,
        }
        return res.status(200).json({...baseResponse});
  } catch (error) {
    next(error);
  }
};

//Make sure to populate the questions
const getMock = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const userId = req.body.user._id.toString();

    const mock = await TelegramMock.findById(id).populate("questions").lean().exec();

    if (!mock) {
      throw new Error('Mock not found with that ID.');
    }

    const questionsUserAnsPromises = mock.questions.map(async (question: any) => {
    const questionId = question._id;
    const userQuestionAnswer = await QuestionUserAnswer.findOne({ userId, questionId }).lean().exec();
    return userQuestionAnswer || { userId, questionId, userAnswer: QuestionAnswers.E };
    });

    const questionsUserAnsResults = await Promise.all(questionsUserAnsPromises);

    const questionsWithUserAns = mock.questions.map((question: any, index: number) => {
      const userAnswer = questionsUserAnsResults[index];
      return {
        question: {...question, isLiked: false},
        userAnswer: userAnswer
      };
    });

    for (const eachQuestionWithUserAns of questionsWithUserAns) {
      const questionId = eachQuestionWithUserAns.question._id;
      const itExists = await UserQuestionVote.findOne({ userId, questionId }).exec();
      if(itExists) {eachQuestionWithUserAns.question.isLiked = true;}
    }

    let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Mock retrieved successfully!'
        baseResponse.data = {
        mock:{
          _id: mock._id,
          name:mock.name,
          userId: userId,
        },
        mockQuestions: questionsWithUserAns
        }

    return res.status(200).json({...baseResponse});
  } catch (error) {
    next(error);
  }
};

const updateMock = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const mockToBeUpdated = await TelegramMock.findById(id).lean().exec();

        if (!mockToBeUpdated) throw Error("Mock not found with that Id.")

        const {
            name, subject, isStandard, examYear, questions,
            departmentId,userId
        } = req.body;

        let updateObject = { name, subject, isStandard, examYear, questions, departmentId,userId}

        for (const key in updateObject){
            if (!updateObject[key]) delete updateObject[key]
        }

        const { error, value } = mockValidator(updateObject,"put");

        if (error) throw error;

        const updatedMock = await Mock.findByIdAndUpdate(id, value, {new:true}).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Mock updated successfully!'
        baseResponse.data = {
            updatedMock,
        }
        return res.status(200).json({...baseResponse})
  } catch (error) {
    next(error);
  }
};

const deleteMock = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const mockToBeDeleted = await TelegramMock.findById(id).lean().exec();

        if (!mockToBeDeleted) throw Error("Mock not found with that Id.");

        const deletedMock = await Mock.findByIdAndDelete(id).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Mock deleted successfully!'
        baseResponse.data = {
            deletedMock,
        }

        return res.status(200).json({...baseResponse});
  } catch (error) {
    next(error);
  }
};

const mockControllers = {
  createMock,
  createStandardMock,
  getMocks,
  getMock,
  updateMock,
  deleteMock
};

export default mockControllers;
