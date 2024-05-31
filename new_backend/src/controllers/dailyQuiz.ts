import { Request, Response, NextFunction } from 'express';
import DailyQuiz from '../models/dailyQuiz';
import { dailyQuizValidator } from '../validations/joiModelValidator';
import { Schema } from 'mongoose';
import Mock, { IMock } from '../models/mock';
import { BaseResponse } from '../types/baseResponse';
import UserDailyQuiz from '../models/userDailyQuiz';
import QuestionUserAnswer, { QuestionAnswers } from '../models/questionUserAnswer';
import Question from '../models/question';
import { ObjectId } from "mongodb"
import UserQuestionVote from '../models/userQuestionVote';
import { logUserDailyActivity, updateUserPoint } from '../services/helpers';
import { UserScoreTracker } from '../types/typeEnum';

const createDailyQuiz = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { day, description, questions } = req.body;

        const userInput = { day, description, questions };

        const { error, value } = dailyQuizValidator(userInput, "post");

        if (error) throw error;

        const existingQuiz = await DailyQuiz.findOne({ day }).lean().exec();
        if (existingQuiz) throw Error("A daily quiz already exists for the specified day.");

        const dailyQuiz = new DailyQuiz({ ...value });

        const savedDailyQuiz = await dailyQuiz.save();

        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'Daily Quiz created successfully!';
        baseResponse.data = {
            newDailyQuiz: savedDailyQuiz
        };

        return res.status(201).json({ ...baseResponse });
    } catch (error) {
        next(error);
    }
};

const getDailyQuizzes = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const dailyQuizzes = await DailyQuiz.find().lean().exec();
        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'Daily Quizzes retrieved successfully!';
        baseResponse.data = {
            dailyQuizzes,
        };

        return res.status(200).json({ ...baseResponse });
    } catch (error) {
        next(error);
    }
};

const getDailyQuiz = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const userId = req.body.user._id.toString();
      const departmentId = req.body.user.department;
      const currentDate = new Date();
  
      const dailyQuiz = await getOrCreateDailyQuiz(currentDate, departmentId);
      
      const foundUserDailyQuiz= await UserDailyQuiz.findOne({ userId, dailyQuizId: dailyQuiz._id }).lean().exec();

      const isSolved = foundUserDailyQuiz ? true : false;
      const userScore = foundUserDailyQuiz ? foundUserDailyQuiz.score : 0;
  
      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Daily Quiz retrieved successfully!';
      baseResponse.data = {
        dailyQuiz,
        isSolved,
        userScore
      };
  
      return res.status(200).json({ ...baseResponse });
  
    } catch (error) {
      next(error);
    }
};

const updateDailyQuiz = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const dailyQuizToBeUpdated = await DailyQuiz.findById(id).lean().exec();

        if (!dailyQuizToBeUpdated) throw Error("Daily Quiz not found with that Id.");

        const { day, description, questions } = req.body;

        let updateObject = { day, description, questions };

        for (const key in updateObject) {
            if (!updateObject[key]) delete updateObject[key];
        }

        const { error, value } = dailyQuizValidator(updateObject, "put");

        if (error) throw error;

        const updatedDailyQuiz = await DailyQuiz.findByIdAndUpdate(id, value, { new: true }).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'Daily Quiz updated successfully!';
        baseResponse.data = {
            updatedDailyQuiz,
        };
        return res.status(200).json({ ...baseResponse });

    } catch (error) {
        next(error);
    }
};

const deleteDailyQuiz = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const dailyQuizToBeDeleted = await DailyQuiz.findById(id).lean().exec();

        if (!dailyQuizToBeDeleted) throw Error("Daily Quiz not found with that Id.");

        const deletedDailyQuiz = await DailyQuiz.findByIdAndDelete(id).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'Daily Quiz deleted successfully!';
        baseResponse.data = {
            deletedDailyQuiz,
        };

        return res.status(200).json({ ...baseResponse });
    } catch (error) {
        next(error);
    }
};

export const getOrCreateDailyQuiz = async (date: Date, departmentId: Schema.Types.ObjectId) => {
    const formattedDate = date;
    formattedDate.setUTCHours(0, 0, 0, 0);

    const existingDailyQuiz = await DailyQuiz.findOne({
        day: formattedDate,
        departmentId,
    }).populate({
        path: 'questions',
        select: 'description choiceA choiceB choiceC choiceD _id' }).lean().exec();

    if (existingDailyQuiz) {
        return existingDailyQuiz;
    }

    const mockQuestions = await getRandomMockQuestions(departmentId);

    const newDailyQuiz = new DailyQuiz({
        day: date,
        departmentId: departmentId,
        questions: mockQuestions,
    });

    const savedDailyQuiz = await newDailyQuiz.save()

    const populatedDailyQuiz = await DailyQuiz.findOne({_id: savedDailyQuiz._id})
    .populate({
        path: 'questions',
        select: 'description choiceA choiceB choiceC choiceD _id' }).lean().exec();

    return populatedDailyQuiz
};

const getRandomMockQuestions = async (departmentId: Schema.Types.ObjectId) => {
  const mocksBySubject:any = await Mock.aggregate([
    { $match: { departmentId, } },
    { $group: { _id: '$subject', mocks: { $push: '$$ROOT' } } },
  ]).exec();

  const selectedQuestions: Schema.Types.ObjectId[] = [];

  for (const subject of mocksBySubject) {
    const mocks = subject.mocks;
    if (mocks.length > 0) {
      const randomMock = mocks[Math.floor(Math.random() * mocks.length)];
      const randomQuestion = randomMock.questions[Math.floor(Math.random() * randomMock.questions.length)];
      selectedQuestions.push(randomQuestion);
    }
  }

  return selectedQuestions;
};

const submitDailyQuizAnswers = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { dailyQuizId, userAnswer } = req.body;
    const userId = req.body.user._id;

    const dailyQuiz:any = await DailyQuiz.findById(dailyQuizId).lean().exec();
    if (!dailyQuiz) {
      throw new Error('Daily Quiz not found!');
    }

    const isSubmitted = await UserDailyQuiz.findOne({dailyQuizId: dailyQuiz._id, userId,}).lean().exec()

    if(isSubmitted){
      throw Error("You have already submitted your answer!");
    }

    const dailyQuizQuestionIds = new Set(dailyQuiz.questions.map(question => question._id.toString()));

    const invalidQuestionIds = userAnswer
    .filter(answer => !dailyQuizQuestionIds.has(answer.questionId))
    .map(answer => answer.questionId);

    if (invalidQuestionIds.length > 0) {
      throw new Error(`Invalid questions found: ${invalidQuestionIds.join(', ')}`);
    }

    const userScorePromises = userAnswer.map(async (answer) => {
      const isCorrect = await validateUserAnswer(answer.questionId, answer.userAnswer);
      
      await QuestionUserAnswer.updateOne(
        { questionId: answer.questionId, userId },
        { userAnswer: answer.userAnswer },
        { upsert: true }
      );

      return isCorrect ? 1 : 0;
    });

    const userScores = await Promise.all(userScorePromises);
    const totalScore = userScores.reduce((acc, score) => acc + score, 0);

    await UserDailyQuiz.updateOne(
      { userId, dailyQuizId },
      { score: totalScore },
      { upsert: true }
    );

    await logUserDailyActivity(userId, new Date(), 'dailyQuiz')

    const userScoreUpdate = new UserScoreTracker()
    userScoreUpdate.previousScore = 0
    userScoreUpdate.currentScore = totalScore

    await updateUserPoint(userId, userScoreUpdate);

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'User answers submitted successfully!';
    baseResponse.data = {
      userScore: totalScore,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const validateUserAnswer = async (questionId: string, userAnswer: QuestionAnswers): Promise<boolean> => {
  const foundQuestion = await Question.findOne({ _id: questionId }).lean().exec();
  return foundQuestion && foundQuestion.answer === userAnswer;
};

const getDailyQuizAnalysis = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const userId = req.body.user._id.toString();
        const id = req.params.id;

        const quiz = await DailyQuiz.findOne({_id:id}).populate({path:"questions", select:"-isForQuiz -isForMock -adminApproval -departmentId -updatedAt -createdAt -difficulty"}).lean().exec();

        if (!quiz) throw Error("Quiz not found with that Id.")

        const questionsUserAnsPromises = quiz.questions.map(async (question: any) => {
        const questionId = question._id;
        const userQuestionAnswer = await QuestionUserAnswer.findOne({ userId, questionId }).select("userId questionId userAnswer -_id").lean().exec();
        return userQuestionAnswer || { userId, questionId, userAnswer: QuestionAnswers.E };
        });
    
        const questionsUserAnsResults = await Promise.all(questionsUserAnsPromises);
    
        const questionsWithUserAns = quiz.questions.map((question: any, index: number) => {
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

        const userDailyQuizScore = await UserDailyQuiz.findOne({userId, dailyQuizId: quiz._id}).select("-_id score").lean().exec()

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Quiz retrieved successfully!'
        baseResponse.data = {
          dailyQuiz:{
            _id: quiz._id,
            description: quiz.description,
            userId: userId,
            userScore: userDailyQuizScore.score
          },
          quizQuestions:questionsWithUserAns,
        }

        return res.status(200).json({...baseResponse});

    } catch (error) {
        next(error)
    }
}

const dailyQuizControllers = {
    createDailyQuiz,
    getDailyQuizzes,
    getDailyQuiz,
    updateDailyQuiz,
    deleteDailyQuiz,
    submitDailyQuizAnswers,
    getDailyQuizAnalysis
};

export default dailyQuizControllers;
