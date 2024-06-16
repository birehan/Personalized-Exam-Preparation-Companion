import { Request, Response, NextFunction } from 'express';
import UserMockScore from '../models/userMockScore';
import UserQuizScore from '../models/userQuizScore';
import User from '../models/user';
import Image from '../models/image';
import UserStatistics from '../models/userStatistics';
import UserContest from '../models/userContest';
import mongoose, { Schema, Types } from "mongoose";
import UserDailyActivity, { IUserDailyActivity } from '../dashboard/models/userDailyActivity';
import { BaseResponse } from '../types/baseResponse';

const getLeaderboard = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const userId = req.body.user._id;

    let page = parseInt(req.query.page as string, 10);
    let limit = parseInt(req.query.limit as string, 10);

    page = isNaN(page) || page <= 0 ? 1 : page;
    limit = isNaN(limit) || limit <= 0 ? 100 : limit;

    const skip = (page - 1) * limit;

    const userStatistics = await UserStatistics.find()
      .sort({ points: -1 })
      .skip(skip)
      .limit(limit);


    const leaderboard = await Promise.all(
      userStatistics.map(async (stats) => {
        const user = await User.findById(stats.userId).populate('avatar');

        if (user) {
          const contestAttended = await UserContest.countDocuments({
            userId: user._id,
            type: 'live',
          }).lean().exec() || 0;

          let avatar = null;
          if (user.avatar) {
            const image = await Image.findById(user.avatar);
            avatar = image ? image.imageAddress : null;
          }

          return {
            _id: user._id,
            firstName: user.firstName,
            lastName: user.lastName,
            avatar,
            points: stats.points,
            maxStreak: stats.maxStreak,
            contestAttended,
          };
        }
      })
    );

    const userRank = await getUserRank(userId);

    const baseResponse = {
      success: true,
      message: 'Leaderboard fetched successfully',
      data: {
        leaderboard,
        userRank,
      },
    };

    return res.status(200).json(baseResponse);
  } catch (error) {
    next(error);
  }
};

const calculateUserRank = async (userId: Schema.Types.ObjectId) => {
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
};

const getUserRank = async (userId: Schema.Types.ObjectId) => {
  const userStats = await UserStatistics.findOne({ userId });

  const user = await User.findById(userId).populate('avatar');

  let avatar = null;
  if (user.avatar) {
    const image = await Image.findById(user.avatar);
    avatar = image ? image.imageAddress : null;
  }

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
      ? {
          _id: userId,
          rank: userIndex,
          avatar,
          firstName: user.firstName,
          lastName: user.lastName,
          points: sortedUsers[userIndex].points,
          maxStreak: sortedUsers[userIndex].maxStreak,
          contestAttended: await UserContest.countDocuments({
            userId: userId,
            type: 'live',
          }).lean().exec() || 0,
        }
      : null;
  }

  const allUsersStats = await UserStatistics.find()
    .sort({ points: -1 })
    .select('userId points maxStreak');

  const userIndex = allUsersStats.findIndex((user) => user.userId.toString() === userId.toString());

  return userIndex !== -1
    ? {
        _id: userId,
        rank: userIndex,
        avatar,
        firstName: user.firstName,
        lastName: user.lastName,
        points: allUsersStats[userIndex].points,
        maxStreak: allUsersStats[userIndex].maxStreak,
        contestAttended: await UserContest.countDocuments({
          userId: userId,
          type: 'live',
        }).lean().exec() || 0,
      }
    : null;
};

const getWeeklyLeaderboard = async (req: Request, res: Response, next: NextFunction) => {
  try {

    const { page = '1', limit = '10' } = req.query;
    const currentPage: number = parseInt(page as string);
    const itemsPerPage: number = parseInt(limit as string);
    const currentDate = new Date();
    const userId = req.body.user._id.toString();
    

    const currentDayOfWeek = currentDate.getDay();
    const startDate = new Date(currentDate);
    startDate.setDate(currentDate.getDate() - currentDayOfWeek + (currentDayOfWeek === 0 ? -6 : 1));
    startDate.setHours(0, 0, 0, 0);

    const endDate = new Date(startDate);
    endDate.setDate(startDate.getDate() + 6);
    endDate.setHours(23, 59, 59, 999);


    const topParticipants = await UserDailyActivity.aggregate([
      {
        $match: {
          day: { $gte: startDate, $lte: endDate }
        }
      },
      {
        $group: {
          _id: '$userId',
          points: {
            $sum: {
              $add: ['$mockCompleted', '$quizCompleted', '$contestCompleted', '$dailyQuizCompleted']
            }
          }
        }
      },
      {
        $sort: { points: -1 }
      },
      {
        $match: {
          points: { $gt: 0 } 
        }
      },
    ]);

    let prevRank = 0;
const sortedTopParticipants = topParticipants.sort((a, b) => b.points - a.points);

const topRanks = [];
for (let index = 0; index < sortedTopParticipants.length; index++) {

  const participant = sortedTopParticipants[index];
  const user = await User.findById(participant._id);
  const image = await Image.findById(user.avatar);
  const userStatistics= await UserStatistics.findOne({userId: participant._id})
  
  
  const currentRank = index === 0 || sortedTopParticipants[index - 1].points !== participant.points
    ? index + 1
    : prevRank;

  prevRank = currentRank;

  topRanks.push({
    _id: participant._id,
    rank: currentRank,
    firstName: user?.firstName,
    lastName: user?.lastName,
    avatar: image?.imageAddress || null,
    maxStreak: userStatistics?.maxStreak,
    points: participant.points,
    contestAttended: await UserContest.countDocuments({
      userId: user._id,
      type: 'live',
    }).lean().exec() || 0,
  });
}
const userRanking= topRanks.filter(score=> score._id.toString() === userId)

const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = currentPage * itemsPerPage;

    const paginatedRanks = topRanks.slice(startIndex, endIndex);
    let baseResponse = new BaseResponse();
    baseResponse.success = true
    baseResponse.message = "Weekly leaderboard retrieved successfully!"
    baseResponse.data = {
      leaderboard: paginatedRanks,
      userRank: userRanking.length > 0? userRanking[0] : null
    }

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error)
  }
};

const getMonthlyLeaderboard = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const userId = req.body.user._id.toString();

    const { page = '1', limit = '10' } = req.query;
    const currentPage: number = parseInt(page as string);
    const itemsPerPage: number = parseInt(limit as string);
    const currentDate = new Date();
    const startDate = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
    const endDate = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0);

    startDate.setHours(0, 0, 0, 0);
    endDate.setHours(23, 59, 59, 999);

    const topParticipants = await UserDailyActivity.aggregate([
      {
        $match: {
          day: { $gte: startDate, $lte: endDate }
        }
      },
      {
        $group: {
          _id: '$userId',
          points: {
            $sum: {
              $add: ['$mockCompleted', '$quizCompleted', '$contestCompleted', '$dailyQuizCompleted']
            }
          }
        }
      },
      {
        $sort: { points: -1 }
      },
      {
        $match: {
          points: { $gt: 0 } 
        }
      }
    ]);

    let prevRank = 0;
const sortedTopParticipants = topParticipants.sort((a, b) => b.points - a.points);

const topRanks = [];
for (let index = 0; index < sortedTopParticipants.length; index++) {
  const participant = sortedTopParticipants[index];
  const user = await User.findById(participant._id);
  const image = await Image.findById(user.avatar);
  const userStatistics= await UserStatistics.findOne({userId: participant._id})
  const currentRank = index === 0 || sortedTopParticipants[index - 1].points !== participant.points
    ? index + 1
    : prevRank;

  prevRank = currentRank;

  topRanks.push({
    _id: participant._id,
    rank: currentRank,
    firstName: user?.firstName,
    lastName: user?.lastName,
    avatar: image?.imageAddress || null,
    maxStreak: userStatistics?.maxStreak,
    points: participant.points,
    contestAttended: await UserContest.countDocuments({
      userId: user._id,
      type: 'live',
    }).lean().exec() || 0,
  });
}

const userRanking= topRanks.filter(score=> score._id.toString() === userId)

const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = currentPage * itemsPerPage;

    const paginatedRanks = topRanks.slice(startIndex, endIndex);
    let baseResponse = new BaseResponse();
    baseResponse.success = true
    baseResponse.message = "Monthly leaderboard retrieved successfully!"
    baseResponse.data = {
      leaderboard: paginatedRanks,
      userRank: userRanking.length > 0? userRanking[0] : null
    }
    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error)
  }
};



const leaderboardController = { getLeaderboard, calculateUserRank, getWeeklyLeaderboard, getMonthlyLeaderboard };

export default leaderboardController;
