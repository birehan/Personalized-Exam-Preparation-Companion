import { Request, Response, NextFunction } from "express";
import QuestionFlag, { IQuestionFlag } from "../models/questionFlag";
import { questionFlagValidator } from "../validations/joiModelValidator";
import Question from "../models/question";
import { BaseResponse } from '../types/baseResponse';

const createUserQuestionFlag = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const userId = req.body.user._id.toString();

    const { questionId, comment } = req.body;

    const userInput = { userId, questionId, comment };

    const { error, value } = questionFlagValidator(userInput, 'post');
    if (error) throw error;

    const foundQuestion = await Question.findOne({ _id: questionId });

    if (!foundQuestion) {
      throw new Error('No question found with that ID');
    }

    const filter = { userId, questionId };
    const update = { $set: { comment }, $setOnInsert: { createdAt: new Date() } };
    const options = { upsert: true, new: true, setDefaultsOnInsert: true };

    const savedQuestionFlag = await QuestionFlag.findOneAndUpdate(filter, update, options);

    let baseResponse = new BaseResponse();

    baseResponse. success = true,
    baseResponse. message = 'Question Flag created/updated successfully!';
    baseResponse.data =  { newQuestionFlag: savedQuestionFlag }

    return res.status(201).json(baseResponse);
  } catch (error) {
    next(error);
  }
};

const getQuestionFlags = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const questionFlags = await QuestionFlag.find().lean().exec();
        let baseResponse = new BaseResponse();

        baseResponse.success = true
        baseResponse.message = 'Question flags retrieved successfully!'
        baseResponse.data = {
            questionFlags,
        }

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error)
    }
}

const questionFlagController = { createUserQuestionFlag, getQuestionFlags};
export default questionFlagController;