import { Request, Response, NextFunction } from 'express';
import DailyQuest, { IDailyQuest } from '../models/dailyQuest';
import { BaseResponse } from '../types/baseResponse';
import UserDailyActivity from '../dashboard/models/userDailyActivity';
import Contest from '../models/contest';
import { Schema } from 'mongoose';
import DailyQuiz from '../models/dailyQuiz';
import { getOrCreateDailyQuiz } from './dailyQuiz';

const createDailyQuest = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { day, topic, dailyQuiz, quiz, mock, contest } = req.body;

    const dailyQuestData = { day, topic, dailyQuiz, quiz, mock, contest };

    const newDailyQuest = new DailyQuest(dailyQuestData);
    const savedDailyQuest = await newDailyQuest.save();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'DailyQuest created successfully!';
    baseResponse.data = {
      newDailyQuest: savedDailyQuest,
    };

    return res.status(201).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getDailyQuests = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const dailyQuests = await DailyQuest.find().lean().exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'DailyQuests retrieved successfully!';
    baseResponse.data = {
      dailyQuests,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getDailyQuest = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const userId = req.body.user._id.toString();
    const currentDate = new Date();

    const dailyQuest = await getOrCreateDailyQuest(currentDate, req.body.user.department);

    const foundUserDailyQuest = await UserDailyActivity.findOne({ userId, day: currentDate.setUTCHours(0, 0, 0, 0)}).lean().exec();

    const dailyQuestResponse = [
      {
        challenge: "Complete Today's Daily Quiz",
        expected: dailyQuest.dailyQuiz,
        completed: Math.min(foundUserDailyQuest?.dailyQuizCompleted? foundUserDailyQuest.dailyQuizCompleted : 0, dailyQuest.dailyQuiz)
      },
      {
        challenge: "Complete Topics",
        expected: dailyQuest.topic,
        completed: Math.min(foundUserDailyQuest?.subchapterCompleted? foundUserDailyQuest.subchapterCompleted : 0 || 0, dailyQuest.topic)
      },
      {
        challenge: "Personal Quizzes",
        expected: dailyQuest.quiz,
        completed: Math.min(foundUserDailyQuest?.quizCompleted? foundUserDailyQuest.quizCompleted : 0 || 0, dailyQuest.quiz)
      },
      {
        challenge: "Complete Mock Exams",
        expected: dailyQuest.mock,
        completed: Math.min(foundUserDailyQuest?.mockCompleted? foundUserDailyQuest.mockCompleted : 0 || 0, dailyQuest.mock)
      },
      {
        challenge: "Join Today's Contest",
        expected: dailyQuest.contest,
        completed: Math.min(foundUserDailyQuest?.contestCompleted? foundUserDailyQuest.contestCompleted : 0 || 0, dailyQuest.contest)
      }
    ]

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'DailyQuest retrieved successfully!';
    baseResponse.data = {
      dailyQuest: dailyQuestResponse
    };

    return res.status(200).json({ ...baseResponse });

  } catch (error) {
    next(error);
  }
};

const updateDailyQuest = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const dailyQuestToUpdate = await DailyQuest.findById(id).lean().exec();

    if (!dailyQuestToUpdate) {
      throw new Error('DailyQuest not found with that ID.');
    }

    const { day, topic, dailyQuiz, quiz, mock, contest } = req.body;
    const updateObject = { day, topic, dailyQuiz, quiz, mock, contest };

    for (const key in updateObject) {
      if (!updateObject[key]) delete updateObject[key];
    }

    const updatedDailyQuest = await DailyQuest.findByIdAndUpdate(id, updateObject, { new: true }).lean().exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'DailyQuest updated successfully!';
    baseResponse.data = {
      updatedDailyQuest,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const deleteDailyQuest = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const dailyQuestToBeDeleted = await DailyQuest.findById(id).lean().exec();

    if (!dailyQuestToBeDeleted) {
      throw new Error('DailyQuest not found with that ID.');
    }

    const deletedDailyQuest = await DailyQuest.findByIdAndDelete(id).lean().exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'DailyQuest deleted successfully!';
    baseResponse.data = {
      deletedDailyQuest,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getOrCreateDailyQuest = async (date: Date, departmentId: Schema.Types.ObjectId ) => {
  const formattedDate = new Date(date);
  formattedDate.setUTCHours(0, 0, 0, 0);

  const existingDailyQuest = await DailyQuest.findOne({
    day: formattedDate,
    departmentId,
  }).lean().exec();

  if (existingDailyQuest) {
    return existingDailyQuest;
  }

  const isWeekend = formattedDate.getDay() === 0 || formattedDate.getDay() === 6;

  const foundContest = await Contest.aggregate([
    {
      $match: {
        departmentId: departmentId,
        startsAt: {
          $gte: formattedDate,
          $lt: new Date(formattedDate.getTime() + 24 * 60 * 60 * 1000),
        }
      }
    },
    {
      $limit: 1
    },
    {
      $project: {
        _id: 1
      }
    }
  ]).exec();

  let foundDailyQuiz = await DailyQuiz.findOne({day: formattedDate, departmentId,}).lean().exec()

  if (!foundDailyQuiz){
    foundDailyQuiz = await getOrCreateDailyQuiz(formattedDate, departmentId);
  }

  //TODO: the following values can be refactored to env variable and can be updated from there!
  const newDailyQuest = new DailyQuest({
    departmentId,
    day: formattedDate,
    topic: 5,
    dailyQuiz: foundDailyQuiz.questions.length > 0 ? 1: 0,
    quiz: 4,
    mock: isWeekend ? 1 : 0,
    contest: foundContest.length > 0 ? 1 : 0
  });

  const savedDailyQuest = await newDailyQuest.save();

  return savedDailyQuest;
};

const dailyQuestControllers = {
  createDailyQuest,
  getDailyQuests,
  getDailyQuest,
  updateDailyQuest,
  deleteDailyQuest,
};

export default dailyQuestControllers;
