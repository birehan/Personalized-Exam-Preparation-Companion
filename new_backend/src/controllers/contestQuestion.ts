import { Request, Response, NextFunction } from 'express';
import ContestQuestion from '../models/contestQuestion';
import { contestQuestionValidation } from '../validations/joiModelValidator';
import { BaseResponse } from '../types/baseResponse';

// Create ContestQuestion
const createContestQuestion = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const {
      contestCategoryId,
      courseId,
      description,
      choiceA,
      choiceB,
      choiceC,
      choiceD,
      answer,
      relatedTopic,
      explanation,
      chapterId,
      subChapterId,
      difficulty
    } = req.body;

    const userInput = {
      contestCategoryId,
      courseId,
      description,
      choiceA,
      choiceB,
      choiceC,
      choiceD,
      answer,
      relatedTopic,
      explanation,
      chapterId,
      subChapterId,
      difficulty
    };

    const { error, value } = contestQuestionValidation(userInput, 'post');

    if (error) throw error;

    const contestQuestion = new ContestQuestion({ ...value });

    const savedContestQuestion = await contestQuestion.save();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Contest Question created successfully!';
    baseResponse.data = {
      newContestQuestion: savedContestQuestion,
    };

    return res.status(201).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getContestQuestions = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const contestQuestions = await ContestQuestion.find().lean().exec();
    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Contest Questions retrieved successfully!';
    baseResponse.data = {
      contestQuestions,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getContestQuestion = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const id = req.params.id;
    const contestQuestion = await ContestQuestion.findOne({ _id: id }).lean().exec();

    if (!contestQuestion) throw Error('Contest Question not found with that Id.');

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Contest Question retrieved successfully!';
    baseResponse.data = {
      contestQuestion,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const updateContestQuestion = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const contestQuestionToBeUpdated = await ContestQuestion.findById(id).lean().exec();

    if (!contestQuestionToBeUpdated) throw Error('Contest Question not found with that Id.');

    const {
      courseId,
      description,
      choiceA,
      choiceB,
      choiceC,
      choiceD,
      answer,
      relatedTopic,
      explanation,
      chapterId,
      subChapterId,
    } = req.body;

    let updateObject = {
      courseId,
      description,
      choiceA,
      choiceB,
      choiceC,
      choiceD,
      answer,
      relatedTopic,
      explanation,
      chapterId,
      subChapterId,
    };

    for (const key in updateObject) {
      if (!updateObject[key]) delete updateObject[key];
    }

    const { error, value } = contestQuestionValidation(updateObject, 'put');

    if (error) throw error;

    const updatedContestQuestion = await ContestQuestion.findByIdAndUpdate(id, value, { new: true })
      .lean()
      .exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Contest Question updated successfully!';
    baseResponse.data = {
      updatedContestQuestion,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const deleteContestQuestion = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const contestQuestionToBeDeleted = await ContestQuestion.findById(id).lean().exec();

    if (!contestQuestionToBeDeleted) throw Error('Contest Question not found with that Id.');

    const deletedContestQuestion = await ContestQuestion.findByIdAndDelete(id).lean().exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Contest Question deleted successfully!';
    baseResponse.data = {
      deletedContestQuestion,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const contestQuestionController = {
  createContestQuestion,
  getContestQuestions,
  getContestQuestion,
  updateContestQuestion,
  deleteContestQuestion,
};

export default contestQuestionController;
