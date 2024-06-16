import { Request, Response, NextFunction } from "express";
import UserQuestionVote from "../models/userQuestionVote";
import { userQuestionVoteValidator } from "../validations/joiModelValidator";
import { BaseResponse } from '../types/baseResponse';
import Question from "../models/question";

const createUserQuestionVote = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const userId = req.body.user._id.toString();

    const { questionId } = req.body;

    const userInput = { userId, questionId };

    const { error, value } = userQuestionVoteValidator(userInput, 'post');
    if (error) throw error;

    const foundVote = await UserQuestionVote.findOne({ userId, questionId});

    if (foundVote) {
      throw new Error('User already liked this question!');
    }

    const foundQuestion = await Question.findOne({_id: questionId}).lean().exec();

    if (!foundQuestion) {
      throw new Error('Question does not exist!');
    }

    const userVote = new UserQuestionVote({...value});

    const savedUserVote = await userVote.save();

    let baseResponse = new BaseResponse();

    baseResponse. success = true,
    baseResponse. message = 'User successfully liked the question!';
    baseResponse.data =  { newUserVote: savedUserVote }

    return res.status(201).json(baseResponse);
  } catch (error) {
    next(error);
  }
};

const deleteUserQuestionVote = async (req: Request, res: Response, next: NextFunction) => {
    try {

        const { id } = req.params;
        const userId = req.body.user._id.toString();
        const userVoteToBeDeleted = await UserQuestionVote.findOne({questionId:id, userId,}).lean().exec();

        if (!userVoteToBeDeleted) throw Error("User vote not found with that Id.");

        const deletedUserVote = await UserQuestionVote.findOneAndDelete({questionId:id, userId,}).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'User vote deleted successfully!'
        baseResponse.data = {
            deletedUserVote,
        }

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error)
    }
}

const userQuestionVoteController = { createUserQuestionVote, deleteUserQuestionVote};
export default userQuestionVoteController;