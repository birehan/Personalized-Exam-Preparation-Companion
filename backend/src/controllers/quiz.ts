import { Request, Response, NextFunction } from 'express';
import { BaseResponse } from '../types/baseResponse';
import Quiz from '../models/quiz';
import { quizValidator } from '../validations/joiModelValidator';
import Chapter from '../models/chapter';
import Question from '../models/question';
import QuestionUserAnswer from '../models/questionUserAnswer';
import { isValidObjectId, shuffleArray } from '../services/helpers';
import { QuestionAnswers } from '../models/questionUserAnswer';
import { ObjectId } from "mongodb"

const createQuiz = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const userId = req.body.user._id.toString();
      const { name, numOfQuestion, chapters, courseId } = req.body;
  
      const userInput = { name, numOfQuestion, chapters, courseId, userId };
  
      const { error, value } = quizValidator(userInput, "post");
  
      if (error) throw error;

      // if (numOfQuestion > 30 ) throw Error("Can't create a quiz with more than 30 questions.")
  
      if (chapters.length > 20) throw Error("Number of chapters should be less than 20.");
  
      const validChapters = await Chapter.find({ _id: { $in: chapters }, courseId }).lean().exec();
  
      if (validChapters.length !== chapters.length) {
        throw Error("One or more chapters sent do not belong to the specified course.");
      }
  
      const questionsPromises = validChapters.map(async (chapter) => {
        return Question.find({ chapterId: chapter._id }).lean().exec();
      });
  
      const chapterQuestionsArray = await Promise.all(questionsPromises);
      const allQuestions = chapterQuestionsArray.flat();
  
      if (!allQuestions || allQuestions.length === 0) {
        throw Error("No questions found for the chapters provided!");
      }

      if (allQuestions.length < numOfQuestion){
        throw Error(`You can't request more than ${allQuestions.length } questions for the selected chapters!`);
      }
  
      const shuffledQuestions = shuffleArray(allQuestions);
      const selectedQuestions = shuffledQuestions.slice(0, numOfQuestion);
  
      const quiz = new Quiz({
        name,
        questions: selectedQuestions.map((question) => question._id),
        courseId,
        userId,
        chapters,
      });
  
      const savedQuiz = await quiz.save();
  
      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = "Quiz created successfully!";
      baseResponse.data = {
        newQuiz: savedQuiz,
      };
  
      return res.status(201).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };

const getUserQuizzes = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const userId = req.body.user._id;
      const courseId  = req.params.id;

      if (!isValidObjectId(courseId)) {
        throw Error('Invalid courseId sent!');
      }
  
      const quizzes = await Quiz.aggregate([
        {
          $match: {
            userId: userId,
            courseId: new ObjectId(courseId)
          }
        },
        {
          $lookup: {
            from: 'userquizscores',
            localField: '_id',
            foreignField: 'quizId',
            as: 'userQuizScores'
          }
        },
        {
          $addFields: {
            score: {
              $ifNull: [
                { $sum: '$userQuizScores.score' },
                0
              ]
            },
            completed: {
              $cond: {
                if: { $gt: [{ $size: "$userQuizScores" }, 0] },
                then: true,
                else: false
              }
            },
            courseId: "$courseId"
          }
        },
        {
          $project: {
            userQuizScores: 0
          }
        }
      ]);
  
      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Quizzes retrieved successfully!';
      baseResponse.data = {
        quizzes
      };
  
      return res.status(200).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };

const getUserQuiz = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const userId = req.body.user._id.toString();
        const id = req.params.id;

        const quiz = await Quiz.findOne({_id:id, userId,}).populate("questions").lean().exec();

        if (!quiz) throw Error("Quiz not found with that Id.")

        const questionsUserAnsPromises = quiz.questions.map(async (question: any) => {
        const questionId = question._id;
        const userQuestionAnswer = await QuestionUserAnswer.findOne({ userId, questionId }).lean().exec();
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


        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Quiz retrieved successfully!'
        baseResponse.data = {
          quiz:{
            _id: quiz._id,
            name: quiz.name,
            userId: userId,
          },
          quizQuestions:questionsWithUserAns,
        }

        return res.status(200).json({...baseResponse});

    } catch (error) {
        next(error)
    }
}

const updateQuiz = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const quizToBeUpdated = await Quiz.findOne({"_id": id}).lean().exec();

        if (!quizToBeUpdated) throw Error("Quiz not found with that Id.")

        const { name, questions,courseId,userId } = req.body;

        let updateObject = { name, questions,courseId,userId };

        for (const key in updateObject){
            if (!updateObject[key]) delete updateObject[key]
        }

        const { error, value } = quizValidator(updateObject,"put");

        if (error) throw error;

        const updatedQuiz = await Quiz.findByIdAndUpdate(id, value, {new: true}).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Quiz updated successfully!'
        baseResponse.data = {
            updatedQuiz,
        }
        return res.status(200).json({...baseResponse})

    } catch (error) {
        next(error)
    }
}

const deleteQuiz = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const quizToBeDeleted = await Quiz.findOne({"_id": id}).lean().exec();

        if (!quizToBeDeleted) throw Error("Quiz not found with that Id.");

        const deletedQuiz = await Quiz.findByIdAndDelete(id).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Quiz deleted successfully!'
        baseResponse.data = {
            deletedQuiz,
        }

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error)
    }
}

const quizControllers = {createQuiz, getUserQuiz, getUserQuizzes, updateQuiz, deleteQuiz}

export default quizControllers