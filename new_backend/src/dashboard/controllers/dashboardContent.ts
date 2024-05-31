import { Request, Response, NextFunction } from 'express';
import { BaseResponse } from '../../types/baseResponse';
import DailyActivity from '../models/dailyActivity';
import { calculateDailyRate, calculateWeeklyRate, chapterCompleted, 
    fillMissingStats, getDailyQuestionStats, getMockStatsController, getQuizStatsController, 
    getTotalUsers, 
    mocksCovered, questionsCompleted, topicsCompleted } from '../../services/helpers';

const getDailyActivityData = async ( req: Request, res: Response, next: NextFunction ) => {
  try {
        const { startDate, endDate } = req.query;

        if (!startDate || !endDate) {
        throw new Error('Both startDate and endDate are required.');
        }

        const start = new Date(startDate as string);
        start.setUTCHours(0, 0, 0, 0);

        const end = new Date(endDate as string);
        end.setUTCHours(0, 0, 0, 0);
        end.setDate(end.getDate() + 1);

        const today = new Date();
        today.setUTCHours(0, 0, 0, 0);

        // daily stats for the specified period
        const dailyStats = await DailyActivity.aggregate([
        {
            $match: {
            day: { $gte: start, $lt: end },
            },
        },
        {
            $group: {
            _id: '$day',
            total: { $sum: { $size: '$uniqueUserIds' } },
            },
        },
        {
            $sort: {
            _id: 1,
            },
        },
        ]);

        // Fill missing days with 0 dailyUsers
        const result = fillMissingStats(dailyStats, start, end);

        // total daily active users
        const totalStats = await DailyActivity.aggregate([
        {
            $match: {
            day: { $eq: today },
            },
        },
        {
            $group: {
            _id: null,
            totalUsers: { $sum: { $size: '$uniqueUserIds' } },
            },
        },
        ]);

        const total = totalStats.length > 0 ? totalStats[0].totalUsers : 0;

        // daily rate of change
        const rate = await calculateDailyRate(today);

        const baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'Daily and Weekly stats retrieved successfully';
        baseResponse.data = {
            dailyStats: result,
            totalUsers: total,
            rateOfChange: rate,
        };

        return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getStaticData= async(req: Request, res: Response, next: NextFunction) => {
  try {
    let questionsSolved = await questionsCompleted();
    let topicsCovered = await topicsCompleted();
    let chaptersCovered= await chapterCompleted()
    let mocksCompleted = await mocksCovered()
    let totalNumberOfUsers= await getTotalUsers()
  
    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Static dashboard data received';
    baseResponse.data = {
      questionsSolved,
      topicsCovered,
      chaptersCovered,
      mocksCompleted,
      totalNumberOfUsers
    };
  
    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
}

//Dynamic Data
const getQuizMockStatsController = async ( req: Request, res: Response, next: NextFunction ) => {
    try {
      const { startDate, endDate, subject } = req.query;

      if (!startDate || !endDate) {
        throw new Error('Both startDate and endDate are required.');
      }

      //Get mock results
      const mockStatsContent = await getMockStatsController({ startDate, endDate, subject });

      //Get quiz results
      const quizStatsContent = await getQuizStatsController({ startDate, endDate, subject });
  
      const baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Quiz and Mock stats retrieved successfully';
      baseResponse.data = {
        mockStatsContent,
        quizStatsContent
      };
      res.status(200).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
};

export const getQuestionStatsController = async ( req: Request, res: Response, next: NextFunction ) => {
    try {
      const { startDate, endDate } = req.query;
  
      if (!startDate || !endDate) {
        throw new Error('Both startDate and endDate are required.');
      }
  
      const start = new Date(startDate as string);
      start.setUTCHours(0, 0, 0, 0);
      
      const end = new Date(endDate as string);
      end.setUTCHours(0, 0, 0, 0);
      end.setDate(end.getDate() + 1);
  
      const dailyStats = await getDailyQuestionStats(start, end);
  
      const stats = await calculateWeeklyRate(start, end);
  
      const baseResponse = {
        success: true,
        message: 'Question stats retrieved successfully',
        data: {
          dailyStats,
          total: stats.total,
          rate: stats.rate,
        },
      };
  
      res.status(200).json(baseResponse);
    } catch (error) {
      next(error);
    }
  };

const dashboardContentController = { getDailyActivityData, getStaticData, getQuizMockStatsController, getQuestionStatsController }

export default dashboardContentController;