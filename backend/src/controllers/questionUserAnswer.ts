import { Request, Response, NextFunction } from 'express';
import QuestionUserAnswer from '../models/questionUserAnswer';
import { BaseResponse } from '../types/baseResponse';
import { questionUserAnswerValidator } from '../validations/joiModelValidator';
import Question from '../models/question';
import { IQuestionUserAnswer } from '../models/questionUserAnswer';
import { UpdateQuery } from "mongoose";

const createQuestionUserAnswer = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const userId = req.body.user._id.toString();
        const { questionId, userAnswer } = req.body;

        const userInput = { questionId, userId, userAnswer }

        const { error, value } = questionUserAnswerValidator(userInput,"post");

        if (error) throw error

        const foundQuestion = await Question.findOne({_id: questionId});

        if(!foundQuestion) throw Error("No question found by that ID");

        const questionUserAnswer = new QuestionUserAnswer(value);

        const savedQuestion_User_Answer = await questionUserAnswer.save();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Answer Recorded successfully!'
        baseResponse.data = {
            newQuestion_User_Answer: savedQuestion_User_Answer
        }

        return res.status(201).json({ ...baseResponse })
    } catch (error) {
        next(error)
    };
}

const upsertQuestionUserAnswer = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const userId = req.body.user._id.toString();
      const { questionId, userAnswer } = req.body;
  
      const userInput = { questionId, userId, userAnswer };
  
      const { error, value } = questionUserAnswerValidator(userInput, "post");
  
      if (error) throw error;
  
      const foundQuestion = await Question.findOne({ _id: questionId });
  
      if (!foundQuestion) throw Error("No question found by that ID");
  
      const filter = { questionId, userId };
      const update: UpdateQuery<IQuestionUserAnswer> = { ...value, $setOnInsert: { createdAt: new Date() } };
      const options = { upsert: true, new: true, setDefaultsOnInsert: true };
  
      const savedQuestion_User_Answer = await QuestionUserAnswer.findOneAndUpdate(filter, update, options);
  
      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Answer Recorded successfully!';
      baseResponse.data = {
        newQuestion_User_Answer: savedQuestion_User_Answer,
      };
  
      return res.status(201).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };

  const upsertQuestionUserAnswers = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { questionUserAnswers } = req.body;
      const userId = req.body.user._id.toString();

      if (!questionUserAnswers) throw Error("No questionUserAnswers sent!");
  
      const validationResult = questionUserAnswers.map((answer) => questionUserAnswerValidator({...answer, userId}, "post"));
  
      const errors = validationResult.filter((result) => result.error);
      if (errors.length > 0) {
        throw errors[0].error;
      }
  
      const questionIds = questionUserAnswers.map((answer) => answer.questionId);
      const foundQuestions = await Question.find({ _id: { $in: questionIds } });
  
      const invalidQuestionIds = questionIds.filter((id) => !foundQuestions.some((question) => question._id.equals(id)));
      if (invalidQuestionIds.length > 0) {
        throw Error("No questions found for the following IDs: " + invalidQuestionIds.join(", "));
      }
  
      const operations = questionUserAnswers.map(async (answer) => {
        answer.userId = userId;

        const filter = { questionId: answer.questionId, userId: answer.userId };
        const update: UpdateQuery<IQuestionUserAnswer> = { ...answer, $setOnInsert: { createdAt: new Date() } };
        return QuestionUserAnswer.updateOne(filter, update, { upsert: true, setDefaultsOnInsert: true })
          .then(() => QuestionUserAnswer.findOne(filter)); // Find the upserted document
      });
      
      const savedQuestion_User_Answers = await Promise.all(operations);

  
      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Answers Recorded successfully!';
      baseResponse.data = {
        newQuestion_User_Answers: savedQuestion_User_Answers,
      };
  
      return res.status(201).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };

const getQuestionsUserAnswers = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const questions_users_answers = await QuestionUserAnswer.find().lean().exec();
        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Questions answer retrieved successfully!'
        baseResponse.data = {
            questions_users_answers,
        }

        return res.status(200).json({ ...baseResponse });
    } catch (error) {
        next(error)
    }
}

const getQuestionUserAnswer = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const id = req.params.id;
        const questions_answer = await QuestionUserAnswer.findOne({ _id: id }).lean().exec();

        if (!questions_answer) throw Error("Questions Answer not found with that Id.")

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Question Answer retrieved successfully!'
        baseResponse.data = {
            questions_answer,
        }

        return res.status(200).json({ ...baseResponse });

    } catch (error) {
        next(error)
    }
}

const updateQuestionUserAnswer = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const questionAnswerToBeUpdated = await QuestionUserAnswer.findById(id).lean().exec();

        if (!questionAnswerToBeUpdated) throw Error("Questions Answer not found with that Id.")

        const { userAnswer } = req.body;

        let updateObject = { userAnswer }

        for (const key in updateObject) {
            if (!updateObject[key]) delete updateObject[key]
        }

        //We need validation first here
        const { error, value } = questionUserAnswerValidator(updateObject,"put");
        
        if (error) throw error

        const updatedQuestionsAnswer = await QuestionUserAnswer.findByIdAndUpdate(id, updateObject, {new: true}).lean().exec();
        
        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Questions Answer updated successfully!'
        baseResponse.data = {
            updatedQuestionsAnswer,
        }
        return res.status(200).json({ ...baseResponse })

    } catch (error) {
        next(error)
    }
}

const deleteQuestionUserAnswer = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const questionToBeDeleted = await QuestionUserAnswer.findById(id).lean().exec();

        if (!questionToBeDeleted) throw Error("Questions Answer not found with that Id.");

        const deletedQuestion = await QuestionUserAnswer.findByIdAndDelete(id).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Question deleted successfully!'
        baseResponse.data = {
            deletedQuestion,
        }

        return res.status(200).json({ ...baseResponse });
    } catch (error) {
        next(error)
    }
}

const questionUserAnswerControllers = { upsertQuestionUserAnswer, upsertQuestionUserAnswers, createQuestionUserAnswer, getQuestionsUserAnswers, getQuestionUserAnswer, updateQuestionUserAnswer, deleteQuestionUserAnswer }

export default questionUserAnswerControllers