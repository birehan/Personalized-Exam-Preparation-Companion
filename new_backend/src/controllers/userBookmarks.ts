import { Request, Response, NextFunction } from "express";
import UserQuestionVote from "../models/userQuestionVote";
import UserContentBookmark from "../models/userContentBookmark";
import { userQuestionVoteValidator } from "../validations/joiModelValidator";
import { BaseResponse } from '../types/baseResponse';
import QuestionUserAnswer, { QuestionAnswers } from "../models/questionUserAnswer";
import Question from "../models/question";
import { logActiveUser } from "../services/helpers";

const getUserBookmarks = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const userId = req.body.user._id.toString();
    const departmentId = req.body.user.department.toString();

    const loggedUser = await logActiveUser(userId, departmentId);

    const userVotes = await UserQuestionVote.find({ userId }).lean().exec();

    const bookmarkedQuestionIds = userVotes.map((vote) => vote.questionId);
    const bookmarkedQuestions = await Question.find({ _id: { $in: bookmarkedQuestionIds } }).lean().exec();

    const questionsUserAnsPromises = bookmarkedQuestions.map(async (question: any) => {
    const questionId = question._id;
    const userQuestionAnswer = await QuestionUserAnswer.findOne({ userId, questionId }).lean().exec();
    return userQuestionAnswer || { userId, questionId, userAnswer: QuestionAnswers.E };
    });

    const questionsUserAnsResults = await Promise.all(questionsUserAnsPromises);

    const questionsWithUserAns = bookmarkedQuestions.map((question: any, index: number) => {
        const userAnswer = questionsUserAnsResults[index];
        const curUserVote = userVotes[index];
        return {
        question: {...question, isLiked: false},
        userAnswer: userAnswer,
        updatedAt: curUserVote.updatedAt
        };
    });

    for (const eachQuestionWithUserAns of questionsWithUserAns) {
        const questionId = eachQuestionWithUserAns.question._id;
        const itExists = await UserQuestionVote.findOne({ userId, questionId }).lean().exec();
        if(itExists) {eachQuestionWithUserAns.question.isLiked = true;}
    }

    const userbookmarkedContents = await UserContentBookmark.find({ userId }).populate("contentId").lean().exec();


    let baseResponse = new BaseResponse();

    baseResponse. success = true,
    baseResponse. message = 'User successfully liked the question!';
    baseResponse.data =  { 
        bookmarkedQuestions: questionsWithUserAns,
        bookmarkedContents: userbookmarkedContents
    }

    return res.status(201).json(baseResponse);
  } catch (error) {
    next(error);
  }
};



const userBookmarksController = { getUserBookmarks };
export default userBookmarksController;