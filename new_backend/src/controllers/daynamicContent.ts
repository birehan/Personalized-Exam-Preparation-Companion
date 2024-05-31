import { Request, Response, NextFunction } from 'express';
import { BaseResponse } from '../types/baseResponse';
import UserDailyActivity from '../dashboard/models/userDailyActivity';
import UserStatistics from '../models/userStatistics';

const getUserStreak = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const startDate = req.query.startDate.toString();
    const endDate  = req.query.endDate.toString();
    const userId = req.body.user._id.toString();

    if (!startDate || !endDate || !userId) {
      throw new Error('startDate, endDate, and userId are required in the request body.');
    }

    const start = new Date(startDate);
    const end = new Date(endDate);

    const userDailyStreak = await getStreak(userId, start, end);
    const totalStreak = await UserStatistics.findOne({userId,}).lean().exec() || {maxStreak: 0, currentStreak:0, points:0};

    const baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'User streak retrieved successfully';
    baseResponse.data = {
        userDailyStreak,
        totalStreak,
    };
    res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getStreak = async (userId: string, startDate: Date, endDate: Date) => {
    const userActivityList: any[] = await UserDailyActivity.find({
      userId,
      day: { $gte: startDate, $lte: endDate }
    });
  
    const activeDaysSet = new Set(userActivityList.map(activity => activity.day.toISOString()));
  
    const daysInRange = [];
    let currentDate = new Date(startDate);
    currentDate.setUTCHours(0, 0, 0, 0);
  
    while (currentDate <= endDate) {
      daysInRange.push(currentDate.toISOString());
      currentDate.setDate(currentDate.getDate() + 1);
    }
  
    const userStreak = daysInRange.map(day => ({
      date: day,
      activeOnDay: activeDaysSet.has(day),
    }));
  
    return userStreak;
  };
  

  const userStreakController = {getUserStreak}

  export default userStreakController
