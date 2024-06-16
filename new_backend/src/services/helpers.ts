import mongoose, { Schema, Types } from "mongoose";
import DailyActivity from "../dashboard/models/dailyActivity";
import TotalChapterCompleted from "../dashboard/models/totalChapterCompleted";
import TotalTopicCompleted from "../dashboard/models/totalTopicCompleted";
import Mock from "../models/mock";
import UserMockScore from "../models/userMockScore";
import Quiz from "../models/quiz";
import QuestionUserAnswer from "../models/questionUserAnswer";
import { Subject, UserScoreTracker } from "../types/typeEnum";
import User from "../models/user";
import { ObjectId } from "mongodb";
import Reviewer from "../dashboard/models/reviewer";
import DashboardUser from "../dashboard/models/dashboardUser";
import UserChapterAnalysis from "../models/userChapterAnalysis";
import Chapter from "../models/chapter";
import Course from "../models/course";
import UserDailyActivity, { IUserDailyActivity } from "../dashboard/models/userDailyActivity";
import UserContest from "../models/userContest";
import Contest from "../models/contest";
import ContestCategory from "../models/contestCategory";
import ContestQuestion from "../models/contestQuestion";
import ContestPrize from "../models/contestPrize";
import UserContestCategory from "../models/userContestCategory";
import UserStatistics from "../models/userStatistics";
import DailyQuest, { IDailyQuest } from "../models/dailyQuest";
import CoinIncentivization, { ICoinIncentivization } from "../models/coinIncentivization";
import CryptoJS from 'crypto-js';
import configs from "../config/configs";

// Helper function to shuffle the array
export const shuffleArray = (array: any[]) => {
    const shuffledArray = [...array];
    for (let i = shuffledArray.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [shuffledArray[i], shuffledArray[j]] = [shuffledArray[j], shuffledArray[i]];
    }
    return shuffledArray;
};

export const isEmailOrPhoneNumber = (input: string) => {
  const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;

  const phoneRegex = /^\+\d{11,}$/;

  if (emailRegex.test(input)) {
    return "Email";
  } else if (phoneRegex.test(input)) {
    return "Phone Number";
  } else {
    return "Neither Email nor Phone Number";
  }
};

export const isValidObjectId = (id) => {
  return mongoose.Types.ObjectId.isValid(id);
}

export const strToBool= (str: string) => {
  return str.toLowerCase() === 'true';
}

export const logActiveUser = async (userId: string, departmentId: string) => {
  const today = new Date();
  const startOfDay = new Date(today.getFullYear(), today.getMonth(), today.getDate());
  const filter = { day: startOfDay, departmentId:  departmentId};
  const update = { $addToSet: { uniqueUserIds: userId } };

  // Use upsert to insert a new record if it doesn't exist or update the existing record
  await DailyActivity.findOneAndUpdate(filter, update, { upsert: true, new: true });

  return true
}

export const logTotalChapterCompleted = async (departmentId: String, subject: String, day: Date) => {
  day.setHours(0, 0, 0, 0);

  const filter = { departmentId, day, subject };
  const update = { $inc: { count: 1 } };
  const options = { upsert: true, new: true };

  await TotalChapterCompleted.findOneAndUpdate(filter, update, options).exec();

  return true;
};

export const logTotalTopicCompleted = async ( departmentId: String, subject: String, day: Date) => {
  day.setHours(0, 0, 0, 0);

  const filter = { departmentId, subject, day, };
  const update = { $inc: { count: 1 } };
  const options = { upsert: true, new: true };

  await TotalTopicCompleted.findOneAndUpdate(filter, update, options).exec();

  return true;
};

export const logUserDailyActivity  = async (userId: Schema.Types.ObjectId, day: Date, type: string, incrementBy: number = 0) => {
  day.setUTCHours(0, 0, 0, 0);

  let foundDailyActivity = await UserDailyActivity.exists({userId, day,});

  //Update consistency once
  if(!foundDailyActivity){
    const previousDay = new Date(day);
    previousDay.setDate(previousDay.getDate() - 1);
    previousDay.setUTCHours(0, 0, 0, 0);

    const isUserActiveYesterday = await UserDailyActivity.exists({ userId, day: previousDay, }) ? true : false;

    const logConsistency = await logUserStreak(userId, isUserActiveYesterday); 
  }

  const filter = { userId, day };
  const update = { $inc: { [`${type}Completed`]: 1 + incrementBy } };
  const options = { upsert: true, new: true };

  foundDailyActivity = await UserDailyActivity.findOneAndUpdate(filter, update, options).exec();

  const dailyQuestCompleted = await hasUserCompletedChallenges(foundDailyActivity)

  if(dailyQuestCompleted){
    const userScoreUpdate = new UserScoreTracker()
    userScoreUpdate.previousScore = 0
    userScoreUpdate.currentScore = 5

    await updateUserPoint(userId, userScoreUpdate);
  }

  return true;
};

export const hasUserCompletedChallenges = async (userDailyActivity): Promise<boolean> => {
  try {
    const currentDate = new Date();
    currentDate.setUTCHours(0, 0, 0, 0);

    const dailyQuest = await DailyQuest.findOne({ day: currentDate }).lean().exec();

    if (!dailyQuest) {
      return false;
    }

    const challengesCompleted =
      userDailyActivity.quizCompleted >= dailyQuest.dailyQuiz &&
      userDailyActivity.chapterCompleted >= dailyQuest.topic &&
      userDailyActivity.quizCompleted >= dailyQuest.quiz &&
      userDailyActivity.mockCompleted >= dailyQuest.mock &&
      userDailyActivity.contestCompleted >= dailyQuest.contest;

    return challengesCompleted;
  } catch (error) {
    console.error('Error checking completed challenges:', error);
    throw error;
  }
};

export const fillMissingStats = ( stats: Array<{ _id: Date | string; total: number }>, startDate: Date, endDate: Date ): Array<{ _id: Date; total: number }> => {
  const result = [];
  let currentDate = new Date(startDate);
  currentDate.setUTCHours(0, 0, 0, 0);

  while (currentDate < endDate) {
    const matchingStat = stats.find((stat) => {
      const statDate = typeof stat._id === 'string' ? new Date(stat._id) : stat._id;
      return statDate.toISOString() === currentDate.toISOString();
    });

    if (matchingStat) {
      result.push({
        _id: new Date(matchingStat._id),
        total: matchingStat.total,
      });
    } else {
      result.push({
        _id: new Date(currentDate),
        total: 0,
      });
    }

    currentDate.setDate(currentDate.getDate() + 1);
  }

  return result;
};

export const calculateMonthlyRate = async ( startDate: Date, endDate: Date, subject?: string ) => {
  const lastMonthStartDate = new Date(startDate);
  lastMonthStartDate.setMonth(lastMonthStartDate.getMonth() - 1);

  const lastMonthEndDate = new Date(startDate);
  lastMonthEndDate.setUTCHours(0, 0, 0, 0);

  const lastMonthStats = await getMockStats(lastMonthStartDate, lastMonthEndDate, subject);

  const totalStats = await getMockStats(startDate, endDate, subject);

  const lastMonthTotal = lastMonthStats.reduce((total, stats) => total + stats.totalMocks, 0);
  const total = totalStats.reduce((total, stats) => total + stats.totalMocks, 0);

  //rate of change
  return { rate: lastMonthTotal !== 0 ? ((total - lastMonthTotal) / lastMonthTotal) * 100 : total*100, total:total };
};

export const getMockStats = async ( startDate: Date, endDate: Date, subject?: string ): Promise<{ day: Date; totalMocks: number }[]> => {
  const pipeline: any[] = [
    {
      $match: {
        createdAt: { $gte: startDate, $lt: endDate },
      },
    },
    {
      $group: {
          _id: {
            $cond: {
              if: { $ne: ['$createdAt', null] },
              then: {
                $dateToString: {
                  format: '%Y-%m-%d',
                  date: { $toDate: '$createdAt' },
                },
              },
              else: null,
            },
          },
          total: { $sum: 1 },
        },
    },
    {
      $sort: {
        _id: 1,
      },
    },
  ];

  if (subject) {
    const mockIds = await Mock.find({ subject }).distinct('_id');
    pipeline.unshift({
      $match: {
        mockId: { $in: mockIds },
      },
    });
  }

  const stats = await UserMockScore.aggregate(pipeline);

  // Fill in missing days with 0 total mocks
  const result = fillMissingStats(stats, startDate, endDate);
  return result.map((stat: { _id: Date; total: number }) => ({
    day: stat._id,
    totalMocks: stat.total,
  }));
};

export const calculateMonthlyRateForQuizzes = async ( startDate: Date, endDate:Date, subject?: string) => {
  const lastMonthStartDate = new Date(startDate);
  lastMonthStartDate.setDate(lastMonthStartDate.getDate() - 30);
  lastMonthStartDate.setUTCHours(0, 0, 0, 0);

  const lastMonthEndDate = new Date(startDate);
  lastMonthEndDate.setUTCHours(0, 0, 0, 0);

  const lastMonthStats = await getQuizStats(lastMonthStartDate, lastMonthEndDate, subject);

  const totalStats = await getQuizStats(startDate, endDate, subject);
  // console.log("totalStats", lastMonthStats)

  const lastMonthTotal = lastMonthStats.reduce((total, stats) => total + stats.totalQuizzes, 0);
  const total = totalStats.reduce((total, stats) => total + stats.totalQuizzes, 0);
  // console.log("totalStats", lastMonthTotal)

  return { rate: lastMonthTotal !== 0 ? ((total - lastMonthTotal) / lastMonthTotal) * 100 : total * 100, total };
};

export const getQuizStats = async ( startDate: Date, endDate: Date, subject?: string )=> {
  //TODO: The quizzes users worked on should and mocks user worked on should be tracked like 
  const pipeline: any[] = [
    {
      $match: {
        createdAt: { $gte: startDate, $lt: endDate },
      },
    },
    {
      $lookup: {
        from: 'courses',
        localField: 'courseId',
        foreignField: '_id',
        as: 'course',
      },
    },
    ...(subject
      ? [
          {
            $match: {
              'course.name': { $regex: subject, $options: 'i' },
            },
          },
        ]
      : []),
    {
      $group: {
        _id: {
          $dateFromParts: {
            year: { $ifNull: [{ $year: '$createdAt' }, 0] },
            month: { $ifNull: [{ $month: '$createdAt' }, 0] },
            day: { $ifNull: [{ $dayOfMonth: '$createdAt' }, 0] },
          },
        },
        total: { $sum: 1 },
      },
    },
    {
      $sort: {
        '_id.year': 1,
        '_id.month': 1,
        '_id.day': 1,
      },
    },
  ];

  const stats = await Quiz.aggregate(pipeline);

  // Fill in missing days with 0 total quizzes
  const result = fillMissingStats(stats, startDate, endDate);

  return result.map((stat: { _id: Date; total: number }) => ({
    day: stat._id,
    totalQuizzes: stat.total,
  }));
};

export const getMockStatsController = async ({ startDate, endDate, subject }) => {
  try {

    if (!startDate || !endDate) {
      throw new Error('Both startDate and endDate are required.');
    }

    const start = new Date(startDate as string);
    start.setUTCHours(0, 0, 0, 0);

    const end = new Date(endDate as string);
    end.setUTCHours(0, 0, 0, 0);
    end.setDate(end.getDate() + 1);

    // total mocks solved stats
    const stats = await getMockStats(start, end, subject as string);

    // monthly rate of change
    const rate_total = await calculateMonthlyRate(start, end, subject as string);

    const mockdata = {
      mockStats: stats,
      rate: rate_total.rate,
      total: rate_total.total
    };

    return mockdata
  } catch (error) {
      throw error;
  }
};

export const getQuizStatsController = async ( { startDate, endDate, subject }) => {
  try {

    if (!startDate || !endDate) {
      throw new Error('Both startDate and endDate are required.');
    }

    const start = new Date(startDate as string);
    start.setUTCHours(0, 0, 0, 0);

    const end = new Date(endDate as string);
    end.setUTCHours(0, 0, 0, 0);
    end.setDate(end.getDate() + 1);

    const stats = await getQuizStats(start, end, subject as string);

    const rateTotal = await calculateMonthlyRateForQuizzes(start, end, subject as string);

    const quizData = {
      quizStats: stats,
      rate: rateTotal.rate,
      total: rateTotal.total,
    };

    return quizData
  } catch (error) {
    throw error
  }
};

export const calculateDailyRate = async (today: Date): Promise<number> => {
  const yesterday = new Date(today);
  yesterday.setDate(today.getDate() - 1);
  yesterday.setUTCHours(0, 0, 0, 0);

  const yesterdayStats = await DailyActivity.aggregate([
  {
      $match: {
      day: { $eq: yesterday },
      },
  },
  {
      $group: {
      _id: null,
      total: { $sum: { $size: '$uniqueUserIds' } },
      },
  },
  ]);

  const yesterdayTotal = yesterdayStats.length > 0 ? yesterdayStats[0].total : 0;

  // total daily active users for today
  const todayStats = await DailyActivity.aggregate([
  {
      $match: {
      day: { $eq: today },
      },
  },
  {
      $group: {
      _id: null,
      total: { $sum: { $size: '$uniqueUserIds' } },
      },
  },
  ]);

  const todayTotal = todayStats.length > 0 ? todayStats[0].total : 0;

  //rate of change
  return yesterdayTotal !== 0 ? ((todayTotal - yesterdayTotal) / yesterdayTotal) * 100 : todayTotal*100;
};

export const lastThirtyDaysData = (data) => {
const lastThirtyDays = new Date();
lastThirtyDays.setDate(lastThirtyDays.getDate() - 30);

return data.filter(item => item.createdAt >= lastThirtyDays);
};
export const lastSixtyDaysData = (data) => {
const lastSixtyDays = new Date();
lastSixtyDays.setDate(lastSixtyDays.getDate() - 60);

return data.filter(item => item.createdAt >= lastSixtyDays);
};
export const percentageCalculator = (lastMonthData, previousMonthData) => {
let percentageDifference = 0;

let reference = previousMonthData;
reference = reference === 0 ? 1 : reference;
percentageDifference = ((lastMonthData - previousMonthData) / reference) * 100;

return percentageDifference;
};

export const questionsCompleted = async (userId?: String) => {
  try {
    let questionsUsersAnswers;

    if (userId) {
      questionsUsersAnswers = await QuestionUserAnswer.find({ userId }).lean().exec();
    } else {
      questionsUsersAnswers = await QuestionUserAnswer.find().lean().exec();
    }

    let lastMonthData = lastThirtyDaysData(questionsUsersAnswers).length;
    let lastSixtyDays = lastSixtyDaysData(questionsUsersAnswers).length;
    let rate = percentageCalculator(lastMonthData, lastSixtyDays - lastMonthData);

    let questionsSolved = {
      total: questionsUsersAnswers.length,
      rate,
    };
    return questionsSolved;
  } catch (error) {
    throw new Error(error);
  }
};

export const getUserCourseAnalysis = async (userId: string)=> {
  try {
    const userChapterAnalysis = await UserChapterAnalysis.find({ userId }).exec();

    const chapterSubChaptersCountMap: Record<string, number> = {};

    for (const analysis of userChapterAnalysis) {
      const chapterId = analysis.chapterId.toString();

      if (!(chapterId in chapterSubChaptersCountMap)) {
        chapterSubChaptersCountMap[chapterId] = 0;
      }

      chapterSubChaptersCountMap[chapterId] += analysis.completedSubChapters.length;
    }

    const userCourseAnalysisResult= {
      "Biology": 0,
      "Physics": 0,
      "Civics": 0,
      "Chemistry":0,
      "Economics": 0,
      "Mathematics": 0,
      "Geography": 0,
      "History": 0,
      "English": 0,
      "SAT" : 0
    };
    let total= 0

    for (const [chapterId, subChaptersCompleted] of Object.entries(chapterSubChaptersCountMap)) {
      const chapter = await Chapter.findById(chapterId).exec();
      total += subChaptersCompleted
      if (chapter) {
        const courseId = chapter.courseId.toString();
        const course = await Course.findById(courseId).exec();

        if (course) {
          let subject = categorizeCourse(course.name as string)
          
          if (!(subject.toString() in userCourseAnalysisResult)){
            userCourseAnalysisResult[subject.toString()] = 0
          }
          if (subject.toString() in userCourseAnalysisResult){
            userCourseAnalysisResult[subject.toString()] += subChaptersCompleted
          }
        }
      }
    }

    const lastThirtyDays= lastThirtyDaysData(userChapterAnalysis)
    const lastSixtyDays= lastSixtyDaysData(userChapterAnalysis)


    let lastMonthData = 0;

    lastThirtyDays.forEach(item => {
      lastMonthData += item.completedSubChapters.length;
    });
  
    let previousMonthData = 0;
    lastSixtyDays.forEach(topic => {
      previousMonthData += topic.completedSubChapters.length;
    });
  
    previousMonthData -= lastMonthData;
    const rate = percentageCalculator(lastMonthData, previousMonthData);
  
    return {
      total,
      rate,
      coursesCount: userCourseAnalysisResult,
    };
  } catch (error) {
    throw error;
  }
};

export const topicsCompleted = async () => {
  try {
    const totalTopicsCompleted = await TotalTopicCompleted.find().lean().exec();
    let total = 0;

    let coursesCount= {
      "Biology": 0,
      "Physics": 0,
      "Civics": 0,
      "Chemistry":0,
      "Economics": 0,
      "Mathematics": 0,
      "Geography": 0,
      "History": 0,
      "English": 0,
      "SAT" : 0
    }


    totalTopicsCompleted.forEach(topic => {
      let {subject, count} = topic
      subject = categorizeCourse(subject as string);
      total += count;
      if (!(subject.toString() in coursesCount)){
        coursesCount[subject.toString()] = 0
      }
      if (subject.toString() in coursesCount){
        coursesCount[subject.toString()] += count
      }
    });

    const lastThirtyDays = lastThirtyDaysData(totalTopicsCompleted);
    const lastSixtyDays = lastSixtyDaysData(totalTopicsCompleted);

    let lastMonthData = 0;

    lastThirtyDays.forEach(item => {
      lastMonthData += item.count;
    });

    let previousMonthData = 0;
    lastSixtyDays.forEach(topic => {
      previousMonthData += topic.count;
    });

    previousMonthData -= lastMonthData;
    const rate = percentageCalculator(lastMonthData, previousMonthData);

    return {
      total,
      rate,
      coursesCount
    };
    
  } catch (error) {
    throw error
  }
};


export const userTotalChaptersCompleted = async (userId: string) => {
  try {

    const userChapterAnalysis = await UserChapterAnalysis.find({ userId }).lean().exec();

    const uniqueChapterIds = new Set<string>();
    userChapterAnalysis.forEach((analysis) => {
      uniqueChapterIds.add(analysis.chapterId.toString());
    });

    const lastThirtyDays = lastThirtyDaysData(userChapterAnalysis);
    const lastSixtyDays = lastSixtyDaysData(userChapterAnalysis);

    let lastMonthData = lastThirtyDays.length ;

    let previousMonthData = lastSixtyDays.length;

    previousMonthData -= lastMonthData;
    const rate = percentageCalculator(lastMonthData, previousMonthData);
    
    const total = uniqueChapterIds.size;

    return {
      total,
      rate 
    };
  } catch (error) {
    throw new Error(error);
  }
};

export const chapterCompleted= async ()=>{
  try{
    const totalChaptesCompleted= await TotalChapterCompleted.find().lean().exec();
    let total = 0;

    totalChaptesCompleted.forEach(chapter => {
      total += chapter.count
    })

    const lastThirtyDays = lastThirtyDaysData(totalChaptesCompleted);
    const lastSixtyDays = lastSixtyDaysData(totalChaptesCompleted);

    let lastMonthData = 0;

    lastThirtyDays.forEach(chapter => {
      lastMonthData += chapter.count;
    });

    let previousMonthData = 0;
    lastSixtyDays.forEach(chapter => {
      previousMonthData += chapter.count;
    });

    previousMonthData -= lastMonthData;
    const rate = percentageCalculator(lastMonthData, previousMonthData);
    

    return {
      total,
      rate,
    };

  }
  catch(error){
    throw error
  }
}

export const getTotalUsers = async () => {
  try {
    const totalUsers = await User.countDocuments();

    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const lastThirtyDaysData = await User.aggregate([
      {
        $match: {
          createdAt: { $gte: thirtyDaysAgo },
        },
      },
      {
        $group: {
          _id: null,
          count: { $sum: 1 },
        },
      },
    ]);

    const thirtyToSixtyDaysAgo = new Date(thirtyDaysAgo);
    thirtyToSixtyDaysAgo.setDate(thirtyToSixtyDaysAgo.getDate() - 30);

    const lastSixtyDaysData = await User.aggregate([
      {
        $match: {
          createdAt: { $gte: thirtyToSixtyDaysAgo, $lt: thirtyDaysAgo },
        },
      },
      {
        $group: {
          _id: null,
          count: { $sum: 1 },
        },
      },
    ]);

    const rate = lastThirtyDaysData.length > 0 && lastSixtyDaysData.length > 0
      ? ((lastThirtyDaysData[0].count - lastSixtyDaysData[0].count) / lastSixtyDaysData[0].count) * 100
      : 0;

    return {
      totalUsers,
      rate,
    };
  } catch (error) {
    throw new Error(error);
  }
}
export const userContestAnalysis = async (userId: string) => {
  try {
    const userContestData = await UserContest.find({ userId }).lean().exec();


    const lastThirtyDays = lastThirtyDaysData(userContestData);
    const lastSixtyDays = lastSixtyDaysData(userContestData);

    const lastMonthData = lastThirtyDays.length;
    let previousMonthData = lastSixtyDays.length;
    previousMonthData -= lastMonthData;

    const rate = percentageCalculator(lastMonthData, previousMonthData);

    const total = userContestData.length;

    return {
      total,
      rate,
    };
  } catch (error) {
    throw new Error(error);
  }
};


export const userChatActivity = async (userId: string) => {
  try {
    const userActivityData = await UserDailyActivity.find({ userId }).lean().exec();

    let total = 0;

    userActivityData.forEach((activity) => {
      total += activity.questionChatCompleted || 0;
      total += activity.contentChatCompleted || 0;
    });

    const lastThirtyDays = lastThirtyDaysData(userActivityData);
    const lastSixtyDays = lastSixtyDaysData(userActivityData);

    let lastMonthData = 0;
    lastThirtyDays.forEach((activity) => {
      lastMonthData += activity.questionChatCompleted || 0;
      lastMonthData += activity.contentChatCompleted || 0;
    });
    let previousMonthData = 0
    lastSixtyDays.forEach((activity) => {
      previousMonthData += activity.questionChatCompleted || 0;
      previousMonthData += activity.contentChatCompleted || 0;
    });
    previousMonthData -= lastMonthData;

    const rate = percentageCalculator(lastMonthData, previousMonthData);

    return {
      total,
      rate
    };
  } catch (error) {
    throw new Error(error);
  }
};


export const mocksCovered = async (userId?: string) => {
try {
  let mockStats;
    let userMockScore;

    const aggregationPipeline: any[] = [];

    if (userId) {
      aggregationPipeline.push({
        $match: { userId: new Types.ObjectId(userId) },
      });
    }

    aggregationPipeline.push(
      {
        $lookup: {
          from: 'mocks',
          localField: 'mockId',
          foreignField: '_id',
          as: 'mock',
        },
      },
      {
        $unwind: '$mock',
      },
      {
        $group: {
          _id: null,
          total: { $sum: 1 },
          nationalExams: {
            $sum: { $cond: [{ $eq: ['$mock.isStandard', true] }, 1, 0] },
          },
          aiGeneratedExams: {
            $sum: { $cond: [{ $eq: ['$mock.isStandard', false] }, 1, 0] },
          },
        },
      },
      {
        $project: {
          _id: 0,
          total: 1,
          nationalExams: 1,
          aiGeneratedExams: 1,
        },
      },
    );


    mockStats = await UserMockScore.aggregate(aggregationPipeline).exec();

    if (userId) {
      userMockScore = await UserMockScore.find({ userId }).lean().exec();
    } else {
      userMockScore = await UserMockScore.find().lean().exec();
    }
  const lastMonthData = lastThirtyDaysData(userMockScore).length;
  const lastSixtyDays = lastSixtyDaysData(userMockScore).length;
  const rate = percentageCalculator(lastMonthData, lastSixtyDays - lastMonthData);
  // const nationalExamsPercentage= (nationalExams / total)*100
  // const aiGeneratedExams= ((total-nationalExams) / total)*100
  mockStats= mockStats.length !== 0 ? mockStats : [
    { 
      "total": 0,
      "nationalExams": 0,
      "aiGeneratedExams": 0,
    }]

  const mocksCompleted = {
    ...mockStats[0],
    rate,
  };
  return mocksCompleted;
} catch (error) {
  throw new Error(error);
}

}

export const getDailyQuestionStats = async ( startDate: Date, endDate: Date ): Promise<{ day: Date; totalQuestions: number }[]> => {
  const pipeline: any[] = [
    {
      $match: {
        createdAt: { $gte: startDate, $lt: endDate },
      },
    },
    {
      $group: {
        _id: {
          $dateToString: {
            format: '%Y-%m-%d',
            date: '$createdAt',
          },
        },
        total: { $sum: 1 },
      },
    },
    {
      $sort: {
        '_id': 1,
      },
    },
  ];

  const stats = await QuestionUserAnswer.aggregate(pipeline);

   const result = fillMissingStats(stats, startDate, endDate);

  return result.map((stat: { _id: Date; total: number }) => ({
    day: stat._id,
    totalQuestions: stat.total,
  }));
};

export const calculateWeeklyRate = async (startDate: Date, endDate: Date) => {
  const weekAgo = new Date(startDate);
  weekAgo.setDate(startDate.getDate() - 7);

  const weeklyStats = await getDailyQuestionStats(weekAgo, startDate);

  const weeklyTotal = weeklyStats.reduce((total, stats) => total + stats.totalQuestions, 0);

  const totalStats = await getDailyQuestionStats(startDate, endDate);

  const total = totalStats.reduce((total, stats) => total + stats.totalQuestions, 0);

  return {rate: weeklyTotal !== 0 ? ((total - weeklyTotal) / weeklyTotal) * 100 : total * 100, total: total };
};


function generateSubjectMappings(): Record<Subject, RegExp> {
  const subjectMappings: Record<Subject, RegExp> = {} as Record<Subject, RegExp>;

  (Object.values(Subject) as Subject[]).forEach((subj) => {
    subjectMappings[subj] = new RegExp(subj.toLowerCase(), 'i');
  });

  return subjectMappings;
}

export const categorizeCourse = (name: string):Subject => {
  const subjectMappings = generateSubjectMappings();

  for (const subj of Object.values(Subject)) {
    const regex = subjectMappings[subj];
    if (regex && regex.test(name)) {
      return subj;
    }
  }

  return Subject.Others;
}


export const isExistingReviewer =  async(reviewerId: string)=> {
    const foundReviewer = await Reviewer.findOne({_id: reviewerId}).lean().exec();

    if(!foundReviewer){
      return false
    }

    const userDetail = await DashboardUser.findOne({_id: foundReviewer.userId}).lean().exec();

    if (!userDetail.isActive){
      return false
    }

    return true

}


export const formatData = (rawData, startDate, endDate, userId) => {
  const formattedData = [];
  const currentDate = new Date(startDate);

  while (currentDate < endDate) {
    const dataForDay = rawData.find(entry => entry.day.getTime() === currentDate.getTime()) || {
      userId: userId,
      day: currentDate,
      quizCompleted: 0,
      chapterCompleted: 0,
      subchapterCompleted: 0,
      mockCompleted: 0,
      questionCompleted: 0,
      dailyQuizCompleted: 0,
      contestCompleted: 0,
      contentChatCompleted: 0,
      questionChatCompleted: 0,
    };

    formattedData.push({
      userId: dataForDay.userId,
      day: currentDate.toISOString(),
      quizCompleted: dataForDay.quizCompleted,
      chapterCompleted: dataForDay.chapterCompleted,
      subchapterCompleted: dataForDay.subchapterCompleted,
      mockCompleted: dataForDay.mockCompleted,
      questionCompleted: dataForDay.questionCompleted,
      dailyQuizCompleted: dataForDay.dailyQuizCompleted || 0,
      contestCompleted: dataForDay.questionCompleted || 0,
      questionChatCompleted: dataForDay.questionChatCompleted || 0,
      contentChatCompleted: dataForDay.contentChatCompleted || 0,
      points: dataForDay.quizCompleted + (dataForDay.contestCompleted || 0) + (dataForDay.dailyQuizCompleted || 0) + (dataForDay.contentChatCompleted || 0) + (dataForDay.questionChatCompleted || 0) + (dataForDay.chapterCompleted || 0) + dataForDay.subchapterCompleted + dataForDay.mockCompleted + dataForDay.questionCompleted
  });

    currentDate.setDate(currentDate.getDate() + 1);
  }

  return formattedData;
};


//contest helpers
export const hasContestEnded = async (contestId: string, userId: string, currentTime: Date): Promise<boolean> => {
  const userContest = await UserContest.findOne({ userId, contestId });
  const contest = await Contest.findById(contestId);

  if (!userContest || !contest) {
    return false;
  }

  const isLiveNow = currentTime >= contest.startsAt && currentTime <= contest.endsAt;

  if (isLiveNow) {
    return false;
  }

  const contestEndTime = userContest.startedAt.getTime() + (contest.endsAt.getTime() - contest.startsAt.getTime());

  return currentTime.getTime() > contestEndTime;
};


export const getUserScore = async (userId: string, contestId: string): Promise<number> => {
  const userContest = await UserContest.findOne({ userId, contestId });
  return userContest ? userContest.score : 0;
};

export const getContestCategories = async (contestId: string, userId: string) => {
  const contestCategories = await ContestCategory.find({ contestId });

  const categoriesWithQuestions = await Promise.all(
    contestCategories.map(async (category) => {
      const numOfQuestions = await ContestQuestion.countDocuments({ contestCategoryId: category._id });

      const userContestCategory = await UserContestCategory.findOne({ userId, contestCategoryId: category._id });

      const userScore = userContestCategory ? userContestCategory.score : 0;
      const isSubmitted = userContestCategory ? userContestCategory.isSubmitted : false;

      return {
        ...category.toObject(),
        numOfQuestions,
        userScore,
        isSubmitted,
      };
    })
  );

  return categoriesWithQuestions;
};


export const getContestPrizeInfo = async (contestId: string) => {
  const contestPrize = await ContestPrize.findOne({ contestId }).populate('prizeIds').lean().exec();

  return contestPrize ? [...contestPrize.prizeIds] : [];
};

export const getUserconsistency =async (userId, year) => {
  
  if (!userId) {
    throw Error('Please Provide a userId');
  }

  const startDate = new Date(`${year}-01-01`);
  startDate.setUTCHours(0, 0, 0, 0)
  const endDate = new Date(`${year + 1}-01-01`);
  endDate.setUTCHours(0, 0, 0, 0)

  const rawData = await UserDailyActivity.find({
    userId,
    day: { $gte: startDate, $lt: endDate },
  }).sort({ day: 1 }).lean();

  const formattedData = formatData(rawData, startDate, endDate, userId);
  return formattedData
} 

export const logUserStreak = async (userId: Schema.Types.ObjectId, isConsistent: boolean) => {
  try {
    let userStatistics = await UserStatistics.findOne({ userId }).exec();

    if (!userStatistics) {
      userStatistics = new UserStatistics({ userId, maxStreak: 1, currentStreak: 1, points: 0 });
      await userStatistics.save();
      return true
    }

    if (isConsistent) {
      userStatistics.currentStreak += 1;
      userStatistics.maxStreak = Math.max(userStatistics.maxStreak, userStatistics.currentStreak);
    } else {
      userStatistics.maxStreak = Math.max(userStatistics.maxStreak, userStatistics.currentStreak, 1);
      userStatistics.currentStreak = 1;
    }

    await userStatistics.save();
    return true
  } catch (error) {
    throw error;
  }
};


export const updateUserPoint = async ( userId: Schema.Types.ObjectId, userScore: UserScoreTracker): Promise<boolean> => {
  try {
    const diffScore = userScore.currentScore - userScore.previousScore;

    let userStats = await UserStatistics.findOne({ userId });

    if (!userStats) {
      userStats = new UserStatistics({
        userId,
        maxStreak: 1,
        currentStreak: 1,
        points: 0,
      });
    }

    userStats.points = Math.max(userStats.points + diffScore, 0);

    await userStats.save();
    return true
  } catch (error) {
    throw error;
  }
};

export const normalizeScore = (scoreEarned: number, normalizeTo: number, totalToEarn: number): number => {
  return (scoreEarned * normalizeTo) / totalToEarn;
};


export const getUserRank = async (userId: Schema.Types.ObjectId, contestId: Schema.Types.ObjectId): Promise<number> => {
  try {
    const userContest = await UserContest.findOne({ userId, contestId, type: 'live' })
      .sort({ score: -1, finishedAt: 1 })
      .exec();

    if (!userContest) {
      return -1; 
    }

    const allUserContests = await UserContest.find({ contestId, type: 'live' })
      .sort({ score: -1, finishedAt: 1 })
      .exec();

    const userRank = allUserContests.findIndex((contest) => contest.userId.toString() === userId.toString()) + 1;

    return userRank;
  } catch (error) {
    throw error;
  }
};

export const calculateUserRank = async (userId: Schema.Types.ObjectId) => {
  const userStats = await UserStatistics.findOne({ userId });

  if (!userStats) {
    const userStatsWithZero = {
      userId,
      points: 0,
      currentStreak: 0,
      maxStreak: 0,
    };

    const allUsersStats = await UserStatistics.find()
      .sort({ points: -1 })
      .select('userId points maxStreak');

    const sortedUsers = [...allUsersStats, userStatsWithZero].sort((a, b) => b.points - a.points);

    const userIndex = sortedUsers.findIndex((user) => user.userId.toString() === userId.toString());

    return userIndex !== -1
      ? {rank: userIndex + 1, totalScore: sortedUsers[userIndex].points}
      : {rank: 0, totalScore: 0};
  }

  const allUsersStats = await UserStatistics.find()
    .sort({ points: -1 })
    .select('userId points maxStreak');

  const userIndex = allUsersStats.findIndex((user) => user.userId.toString() === userId.toString());

  return userIndex !== -1 ? {rank: userIndex +1, totalScore: allUsersStats[userIndex].points} : {rank: 0, totalScore: 0}
}


function encryptData(data: string, key: string): string {
  return CryptoJS.AES.encrypt(data, key).toString();
}

export function decryptData(encryptedData: string, key: string): string {
  const bytes = CryptoJS.AES.decrypt(encryptedData, key);
  return bytes.toString(CryptoJS.enc.Utf8);
}


export const updateCoinIncentivization= async (userId: string, coin: string, type: string) => {
    try {

      const secretKey = configs.COIN_ENCRIPTION_KEY
        let existingEntity = await CoinIncentivization.findOne({ userId });

        if (!existingEntity) {

          const encryptedCoin = encryptData(coin.toString(), secretKey);
          existingEntity = new CoinIncentivization({
              userId,
              coin: encryptedCoin,
              referralCount: type === 'referral' ? 1 : 0
          });
          existingEntity.save()
         } else {
            const decryptedCoin = parseInt(decryptData(existingEntity.coin, secretKey), 10);
            const updatedCoin = decryptedCoin + parseInt(coin);
            const updatedReferralCount = type === 'referral' ? existingEntity.referralCount + 1 : existingEntity.referralCount;
            const encryptedUpdatedCoin = encryptData(updatedCoin.toString(), secretKey);
            await CoinIncentivization.findOneAndUpdate({ userId }, { coin: encryptedUpdatedCoin, referralCount: updatedReferralCount });
        }
    } catch (error) {
        console.error('Error updating coin incentivization:', error);
        throw error;
    }
}
