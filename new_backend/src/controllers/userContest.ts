import { Request, Response, NextFunction } from 'express';
import UserContest, { IUserContestDocument } from '../models/userContest';
import { userContestValidation } from '../validations/joiModelValidator';
import { BaseResponse } from '../types/baseResponse';
import Contest from '../models/contest';

const createUserContest = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { contestId } = req.body;
    const userId = req.body.user._id.toString();

    const userInput = { contestId, userId };

    const { error, value } = userContestValidation(userInput, 'post');

    if (error) throw error;

    const foundContest = await Contest.findOne({_id: contestId}).lean().exec();

    if (!foundContest) throw Error("There is no contest with that Id!");

    const userIsRegistered = await UserContest.findOne({contestId, userId}).lean().exec();

    if (userIsRegistered) throw Error("User is already registered to this contest!");

    const currentDate = new Date();
    const type = currentDate > foundContest.endsAt ? 'virtual' : 'live';

    const startedAt = type === 'live' ? foundContest.startsAt: currentDate;
    const finishedAt = type === 'live' ? foundContest.endsAt: new Date(currentDate.getTime() + (foundContest.endsAt.getTime() - foundContest.startsAt.getTime()));

    const updateField = type === 'live' ? 'liveRegister' : 'virtualRegister';
    await Contest.findByIdAndUpdate(contestId, { $inc: { [updateField]: 1 } });

    const userContest = new UserContest({ ...value, startedAt, finishedAt, type });

    const savedUserContest = await userContest.save();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'User Contest created successfully!';
    baseResponse.data = {
      newUserContest: savedUserContest,
    };

    return res.status(201).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getUserContests = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const userContests = await UserContest.find().lean().exec();
    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'User Contests retrieved successfully!';
    baseResponse.data = {
      userContests,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getUserContest = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const id = req.params.id;
    const userContest = await UserContest.findOne({ _id: id }).lean().exec();

    if (!userContest) throw Error('User Contest not found with that Id.');

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'User Contest retrieved successfully!';
    baseResponse.data = {
      userContest,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const updateUserContest = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const userContestToBeUpdated = await UserContest.findById(id).lean().exec();

    if (!userContestToBeUpdated) throw Error('User Contest not found with that Id.');

    const { contestId, userId, startedAt, finishedAt, score, type } = req.body;

    let updateObject = { contestId, startedAt, finishedAt, score };

    for (const key in updateObject) {
      if (!updateObject[key]) delete updateObject[key];
    }

    const { error, value } = userContestValidation(updateObject, 'put');

    if (error) throw error;

    const updatedUserContest = await UserContest.findByIdAndUpdate(id, value, { new: true }).lean().exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'User Contest updated successfully!';
    baseResponse.data = {
      updatedUserContest,
    };
    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const deleteUserContest = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const userContestToBeDeleted = await UserContest.findById(id).lean().exec();

    if (!userContestToBeDeleted) throw Error('User Contest not found with that Id.');

    const deletedUserContest = await UserContest.findByIdAndDelete(id).lean().exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'User Contest deleted successfully!';
    baseResponse.data = {
      deletedUserContest,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};
const getNextUpcomingContest = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const userId = req.body.user._id.toString();
    const departmentId = req.body.user.department;
    let baseResponse = new BaseResponse();
    const currentDate = new Date();

    const upcomingContest = await Contest.findOne({
      departmentId: departmentId,
      $or: [
        { startsAt: { $gt: currentDate } },
        { $and: [{ startsAt: { $lte: currentDate } }, { endsAt: { $gte: currentDate } }] },
      ]})
      .sort({ startsAt: 1 })
      .lean()
      .exec();

    if (!upcomingContest) {
      baseResponse.success = true;
      baseResponse.message = 'No upcoming contests found!';
      return res.status(200).json({ ...baseResponse });
    }

    const isLive = currentDate.getTime() >= upcomingContest.startsAt.getTime() && currentDate.getTime() <= upcomingContest.endsAt.getTime();

    const registrationExists = await UserContest.exists({ userId, contestId: upcomingContest._id });
    const hasRegistered = Boolean(registrationExists);

    baseResponse.success = true;
    baseResponse.message = 'Next upcoming contest retrieved successfully!';
    baseResponse.data = {
      contest: {
        ...upcomingContest,
        live: isLive,
        hasRegistered,
        timeLeft: isLive ?  (upcomingContest.endsAt.getTime() - currentDate.getTime())/1000 : Math.max((upcomingContest.startsAt.getTime() - currentDate.getTime())/1000, 0)
      },
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};
const getUserPreviousContests = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const userId = req.body.user._id;
    let baseResponse = new BaseResponse();

    const currentDate = new Date();

    const previousContestsForUser = await UserContest.aggregate([
      {
        $match: {
          userId,
        },
      },
      {
        $lookup: {
          from: 'contests',
          localField: 'contestId',
          foreignField: '_id',
          as: 'contest',
        },
      },
      {
        $unwind: '$contest',
      },
      {
        $sort: { 'contest.startsAt': -1 },
      },
      {
        $project: {
          _id: '$contest._id',
          title: '$contest.title',
          startsAt: '$contest.startsAt',
          endsAt: '$contest.endsAt',
          type: '$type',
          createdAt: '$contest.createdAt',
          updatedAt: '$contest.updatedAt',
        },
      },
    ]);

    if (!previousContestsForUser || previousContestsForUser.length === 0) {
      baseResponse.success = true;
      baseResponse.data = { contests: [] };
      baseResponse.message = 'No previous contests found for the user!';
      return res.status(200).json({ ...baseResponse });
    }

    baseResponse.success = true;
    baseResponse.message = 'Previous contests for the user retrieved successfully!';
    baseResponse.data = {
      contests: previousContestsForUser || [],
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};



const userContestController = {
  createUserContest,
  getUserContests,
  getUserContest,
  updateUserContest,
  deleteUserContest,
  getNextUpcomingContest,
  getUserPreviousContests
};

export default userContestController;
