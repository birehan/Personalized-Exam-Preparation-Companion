import { Request, Response, NextFunction } from 'express';
import { BaseResponse } from '../../types/baseResponse';
import { calculateUserRank, formatData, getUserCourseAnalysis, getUserconsistency, mocksCovered, percentageCalculator, questionsCompleted, userChatActivity, userContestAnalysis, userTotalChaptersCompleted } from '../../services/helpers';
import UserDailyActivity, { IUserDailyActivity } from '../models/userDailyActivity';
import User, { IUserDocument } from '../../models/user';
import UserStatistics from '../../models/userStatistics';

const getUsers = async (req: Request, res: Response, next: NextFunction) => {
  try {

    const { page = 1, limit = 10, search } = req.query;

    const pipeline: any[] = [];

    const userFields = Object.keys(User.schema.paths);

    pipeline.push({
      $project: {
        ...userFields.reduce((projectObj, field) => {
          if (field !== 'password') {
            projectObj[field] = 1;
          }
          return projectObj;
        }, {}),
        fullName: { $concat: ['$firstName', ' ', '$lastName'] },
      },
    });

    if (search) {
      const searchRegex = new RegExp(search as string, 'i');
      const searchStage = {
        $match: {
          $or: [
            { firstName: { $regex: searchRegex } },
            { lastName: { $regex: searchRegex } },
            { email_phone: { $regex: searchRegex } },
          ],
        },
      };
      pipeline.push(searchStage);
    }

    const sortStages: any[] = [];
    const sortString = req.query['sort'] as string;

    if (sortString) {
      const [sortBy, sortOrder] = sortString.split(' ');

      if (userFields.includes(sortBy) && (sortOrder == 'desc' || sortOrder == 'asc')) {
        const sortStage: any = {};
        sortStage[sortBy] = sortOrder === 'desc' ? -1 : 1;
        sortStages.push({ $sort: sortStage });
      }
    }

    const filterStages: any[] = [];
    const filterFieldString = req.query['filterFields'] as string;
    const filterValueString = req.query['filterValues'] as string;

    if (filterFieldString && filterValueString) {
      const filterFields = filterFieldString.split(' ');
      const filterValues = filterValueString.split(' ');

      filterFields.forEach((filterField, index) => {
        if (userFields.includes(filterField) && filterValues[index]) {
          const filterStage: any = {};
          filterStage[filterField] = { $regex: new RegExp(filterValues[index], 'i') };
          filterStages.push({ $match: filterStage });
        }
      });
    }

    pipeline.push({
      $lookup: {
        from: 'userstatistics',
        localField: '_id',
        foreignField: 'userId',
        as: 'userStatistics',
      },
    });

    pipeline.push({
      $lookup: {
        from: 'images',  
        localField: 'avatar',
        foreignField: '_id',
        as: 'avatarData',
      },
    });
    
    const aggregatePipeline = [...pipeline, ...sortStages, ...filterStages];

    aggregatePipeline.push({ $count: 'totalDocuments' });

    const countResult = await User.aggregate(aggregatePipeline);

    const totalDocuments = countResult.length > 0 ? countResult[0].totalDocuments : 0;

    // const totalPages = Math.ceil(totalDocuments / parseInt(limit as string, 10));

    aggregatePipeline.pop();

    // const skip = (parseInt(page as string, 10) - 1) * parseInt(limit as string, 10);
    // aggregatePipeline.push(
    //   {
    //     $skip: skip,
    //   },
    //   {
    //     $limit: parseInt(limit as string),
    //   }
    // );

    const users = await User.aggregate(aggregatePipeline);

    await Promise.all(users.map(async (user) => {
      const userStats = user.userStatistics || null;

      const contestCompleted = await userContestAnalysis(user._id);
      const chaptersCovered = await userTotalChaptersCompleted(user._id);
      const questionsSolved = await questionsCompleted(user._id);

      user.points = userStats.length != 0? userStats[0].points.toFixed(2) : 0;
      user.totalQuestionSolved = questionsSolved.total || 0;
      user.totalChaptesCompleted = chaptersCovered.total || 0;
      user.totalContestParticipated = contestCompleted.total || 0;
      user.maxStreak = userStats.length != 0 ?userStats[0].maxStreak : 0;
    }));

    users.sort((a, b)=> b.points - a.points)

    const totalQuestionSolved = req.query['totalQuestionSolved'] as string;
    const totalChaptesCompleted= req.query['totalQuestionSolved'] as String;
    const totalContestParticipated= req.query['totalContestParticipated'] as String;
    const maxStreak= req.query['maxStreak'] as String;

    if (totalQuestionSolved){
      users.sort((a, b)=> {
        if(totalQuestionSolved =='desc'){
          return b.totalQuestionSolved - a.totalQuestionSolved
        }
        return a.totalQuestionSolved - b.totalQuestionSolved
      })
    }else if(totalChaptesCompleted){
      users.sort((a, b)=> {
        if(totalChaptesCompleted =='desc'){
          return b.totalChaptesCompleted - a.totalChaptesCompleted
        }
        return a.totalChaptesCompleted - b.totalChaptesCompleted
      })
    }else if (totalContestParticipated){
      users.sort((a, b)=> {
        if(totalContestParticipated =='desc'){
          return b.totalContestParticipated - a.totalContestParticipated
        }
        return a.totalContestParticipated - b.totalContestParticipated
      })
    }else if(maxStreak){
      users.sort((a, b)=> {
        if(maxStreak =='desc'){
          return b.maxStreak - a.maxStreak
        }
        return a.maxStreak - b.maxStreak
      })
    }

    const totalPages = Math.ceil(users.length / parseInt(limit as string, 10));
    const startIndex = (parseInt(page as string, 10) - 1) * parseInt(limit as string, 10);
    const endIndex = parseInt(page as string, 10) * parseInt(limit as string, 10);

    const results = users.slice(startIndex, endIndex);

    const baseResponse = {
      success: true,
      message: 'Users fetched successfully',
      data: {
        users:results,
        currentPage: page,
        totalPages
      },
    };

    return res.status(200).json(baseResponse);
  } catch (error) {
    next(error);
  }
};

const getStaticData = async (req: Request, res: Response, next: NextFunction)=> {
  try {
    const userId = req.params.userId;
  
    const user = await User.findById(userId).populate("department", "select _id name")
    .populate("avatar", "select imageAddress -_id")
    .select('-__v -password -createdAt -updatedAt -resetToken')
    .lean().exec();
    if (!user) {
      throw Error("user not found with this ID.")
    }

    if (!userId) {
      throw Error('Please Provide a userId')
    }
    let userCourseAnalysis = await getUserCourseAnalysis(userId)
    let questionsSolved = await questionsCompleted(userId);
    let mocksCompleted = await mocksCovered(userId)
    let chaptersCovered= await userTotalChaptersCompleted(userId)
    let contestCompleted= await userContestAnalysis(userId)
    let userChatUsage= await userChatActivity(userId)
    
    const userRankInfo = await calculateUserRank(user._id);
    const totalStreak = await UserStatistics.findOne({userId: user._id}).lean().exec() || {maxStreak: 0, currentStreak:0, points:0};

    const baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Static dashboard data received';
    baseResponse.data = {
        userData: {...user, ...userRankInfo, ...totalStreak},
        chaptersCovered,
        mocksCompleted,
        questionsSolved,
        topicsCovered: userCourseAnalysis,
        contestCompleted,
        userChatUsage
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getUserDailyActivity = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const userId = req.params.userId;
    const year = parseInt(req.query.year as string) || new Date().getFullYear();
    const formattedData= await getUserconsistency(userId, year)

    const baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message =  'User daily activity received';
    baseResponse.data = formattedData

    return res.status(200).json(baseResponse);
  } catch (error) {
    next(error);
  }
};


const getQuizMockStats = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { startDate, endDate } = req.query;
    const userId = req.params.userId;

    if (!userId) {
      throw new Error('userId is required.');
    }

    if (!startDate || !endDate) {
      throw new Error('Both startDate and endDate are required.');
    }

    const start = new Date(startDate as string);
    start.setUTCHours(0, 0, 0, 0);
    start.setDate(start.getDate() +1)

    const end = new Date(endDate as string);
    end.setUTCHours(0, 0, 0, 0);
    end.setDate(end.getDate() + 1);

    let userStatsCurrent: IUserDailyActivity[] = await UserDailyActivity.find({
      userId,
      day: { $gte: start, $lte: end },
    });

    userStatsCurrent= formatData(userStatsCurrent, start, end,userId)
    const startPast = new Date(start);
    startPast.setDate(startPast.getDate() - (end.getDate() - start.getDate()));
    const endPast = new Date(start);
    endPast.setDate(endPast.getDate() - 1);

    const userStatsPast: IUserDailyActivity[] = await UserDailyActivity.find({
      userId,
      day: { $gte: startPast, $lte: endPast },
    });

    let previousTotalMock= 0
    let previousTotalQuiz= 0

    userStatsPast.map((stat)=>{
      previousTotalMock += stat.mockCompleted
      previousTotalQuiz += stat.quizCompleted
    })

    let currentTotalMock= 0
    const mockStatsContent = userStatsCurrent.map((stat) => {
      currentTotalMock += stat.mockCompleted
      return ({
        day: stat.day,
        mockCompleted: stat.mockCompleted,
        
      })
    });

    const mockStats= {
      total: currentTotalMock,
      rate: percentageCalculator(currentTotalMock, previousTotalMock),
      mockStat: mockStatsContent
    }
    
    let currentTotalQuiz= 0
    const quizStatsContent = userStatsCurrent.map((stat) =>{ 
      currentTotalQuiz += stat.quizCompleted
      return ({
      day: stat.day,
      quizCompleted: stat.quizCompleted,
    })
  });
  let quizStats = {
    total: currentTotalQuiz,
    rate: percentageCalculator(currentTotalQuiz, previousTotalQuiz),
    quizStat: quizStatsContent
  }


    const baseResponse = {
      success: true,
      message: 'Quiz and Mock stats retrieved successfully',
      data: {
        mockStatsContent: mockStats,
        quizStatsContent: quizStats,
      },
    };

    res.status(200).json(baseResponse);
  } catch (error) {
    next(error);
  }
};

const userSpecificController=  {
  getStaticData,
  getUserDailyActivity,
  getQuizMockStats,
  getUsers
};
export default userSpecificController
