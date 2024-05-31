import { Request, Response, NextFunction } from 'express';
import Contest, { IContestDocument } from '../models/contest';
import UserContest from '../models/userContest';
import { contestValidation } from '../validations/joiModelValidator';
import { BaseResponse } from '../types/baseResponse';
import ContestCategory from '../models/contestCategory';
import ContestQuestion from '../models/contestQuestion';
import { getContestCategories, getContestPrizeInfo, getUserRank, getUserScore, hasContestEnded } from '../services/helpers';
import User from '../models/user';
import Department from '../models/department';
import ContestPrize from '../models/contestPrize';
import { updateCoinIncentivization } from './../services/helpers';
import { config } from 'dotenv';
import configs from '../config/configs';

const createContest = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { description, title, startsAt, endsAt, departmentId } = req.body;

    const userInput = { description, title, startsAt, endsAt, departmentId };

    const { error, value } = contestValidation(userInput, 'post');

    if (error) throw error;

    const foundDepartment = await Department.findOne({_id: departmentId}).lean().exec();

    if(!foundDepartment){
      throw Error("No department found with that Id!")
    }

    const contest = new Contest({ ...value });

    const savedContest = await contest.save();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Contest created successfully!';
    baseResponse.data = {
      newContest: savedContest,
    };

    return res.status(201).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getContests = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const contests = await Contest.find().lean().exec();
    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Contests retrieved successfully!';
    baseResponse.data = {
      contests,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getContest = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const id = req.params.id;
    const contest = await Contest.findOne({ _id: id }).lean().exec();

    if (!contest) throw Error('Contest not found with that Id.');

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Contest retrieved successfully!';
    baseResponse.data = {
      contest,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const updateContest = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const contestToBeUpdated = await Contest.findById(id).lean().exec();

    if (!contestToBeUpdated) throw Error('Contest not found with that Id.');

    const { description, title, startsAt, endsAt } = req.body;

    let updateObject = { description, title, startsAt, endsAt };

    for (const key in updateObject) {
      if (!updateObject[key]) delete updateObject[key];
    }

    const { error, value } = contestValidation(updateObject, 'put');

    if (error) throw error;

    const updatedContest = await Contest.findByIdAndUpdate(id, value, { new: true }).lean().exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Contest updated successfully!';
    baseResponse.data = {
      updatedContest,
    };
    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const deleteContest = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const contestToBeDeleted = await Contest.findById(id).lean().exec();

    if (!contestToBeDeleted) throw Error('Contest not found with that Id.');

    const deletedContest = await Contest.findByIdAndDelete(id).lean().exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Contest deleted successfully!';
    baseResponse.data = {
      deletedContest,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};
const getPreviousContests = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const currentDate = new Date();
    let baseResponse = new BaseResponse();

    const previousContests = await Contest.find({
      departmentId: req.body.user.department.toString(),
      endsAt: { $lt: currentDate },
      startsAt: { $lte: currentDate },
    })
      .sort({ endsAt: -1 })
      .lean()
      .exec();

    if (!previousContests || previousContests.length === 0) {
      baseResponse.success = true;
      baseResponse.data = {contests: []}
      baseResponse.message = 'No previous contests found!';
      return res.status(200).json({ ...baseResponse });
    }

    baseResponse.success = true;
    baseResponse.message = 'Previous contests retrieved successfully!';
    baseResponse.data = {
      contests: previousContests,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getContestDetails = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const contestId = req.params.id;
    const userId = req.body.user._id.toString();
    let baseResponse = new BaseResponse();

    const currentTime = new Date();

    const contest = await Contest.findById(contestId);
    if (!contest) {
      throw Error('Contest not found');
    }

    const hasRegistered =  await UserContest.exists({ userId, contestId }) ? true : false;
    const isUpcoming = currentTime < contest.endsAt;
    const hasEnded = hasRegistered ? await hasContestEnded(contestId, userId, currentTime) : false;
    const contestType = isUpcoming ? 'live':'virtual';
    const userScore = hasRegistered ? await getUserScore(userId, contestId) : 0;
    let timeLeft=0;

    const userContest = await UserContest.findOne({userId, contestId}).lean().exec();
    const isLive = hasRegistered? currentTime.getTime() >= userContest.startedAt.getTime() && currentTime.getTime() <= (userContest.startedAt.getTime() + (contest.endsAt.getTime() - contest.startsAt.getTime())) : currentTime.getTime() >= contest.startsAt.getTime() && currentTime.getTime() <= contest.endsAt.getTime();

    const countDown = {
      startsAt: (contestType === 'live' || !hasRegistered) ? contest.startsAt : userContest.startedAt,
      finishAt: contestType === 'live' || !hasRegistered ? contest.endsAt : new Date(userContest.startedAt.getTime() + (contest.endsAt.getTime() - contest.startsAt.getTime())),
    };

    if(contestType === "live"){
      if(currentTime.getTime() < countDown.startsAt.getTime()){
        timeLeft = countDown.startsAt.getTime() - currentTime.getTime();
        if(hasRegistered){ //Set the last time user submitted an answer
          countDown.startsAt = userContest.startedAt
          countDown.finishAt = userContest.finishedAt
        }
      }else if(currentTime.getTime() >= countDown.startsAt.getTime() && currentTime.getTime() <= countDown.finishAt.getTime()){
        timeLeft = countDown.finishAt.getTime() - currentTime.getTime();
        if(hasRegistered){ //Set the last time user submitted an answer
          countDown.startsAt = userContest.startedAt
          countDown.finishAt = userContest.finishedAt
        }
      }else{
        timeLeft = 0; //Update the contest countDown
        if(hasRegistered){ //Set the last time user submitted an answer
          countDown.startsAt = userContest.startedAt
          countDown.finishAt = userContest.finishedAt
        }
      }
    }else{
      if(hasRegistered){
        if(currentTime.getTime() >= countDown.startsAt.getTime() && currentTime.getTime() <= countDown.finishAt.getTime()){
          timeLeft = countDown.finishAt.getTime() - currentTime.getTime();
        }else{
          timeLeft = 0;
        }
        //Set the last time user submitted an answer
        countDown.startsAt = userContest.startedAt
        countDown.finishAt = userContest.finishedAt
      }else{
        timeLeft = countDown.finishAt.getTime() - countDown.startsAt.getTime()
      }
    }

    const contestCategories = await getContestCategories(contestId, userId);
    const prizeInfo = await getContestPrizeInfo(contestId);
    const userRank = await getUserRank(req.body.user._id, contest._id)

    const generalInfo = {
      _id: contest._id.toString(),
      title: contest.title,
      description: contest.description,
      isUpcoming,
      hasRegistered,
      hasEnded,
      contestType,
      userScore,
      countDown,
      isLive,
      timeLeft: timeLeft/1000,
      userRank,
    };

    baseResponse.success = true;
    baseResponse.message = 'Contest detail retrieved successfully!';
    baseResponse.data = {
      generalInfo,
      prizeInfo,
      contestCategories
    };

    return res.status(200).json({ ...baseResponse });

  } catch (error) {
    next(error);
  }
};

const getContestRanking = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const contestId = req.params.id;
    const userId = req.body.user._id.toString();
    let baseResponse = new BaseResponse();

    const currentTime = new Date();

    const foundContest = await Contest.findOne({ _id: contestId }).lean().exec();

    if (!foundContest) {
      throw new Error("No contest found with that Id.");
    }

    if (currentTime < foundContest.startsAt) {
      baseResponse.success = true;
      baseResponse.message = 'Contest is upcoming, no ranking available.';
      baseResponse.data = {
        rankings: [],
        userRank: null,
      };
      return res.status(200).json({ ...baseResponse });
    }

    const userContests = await UserContest.find({ contestId, type: "live" })
      .select("_id startedAt finishedAt score type contestId userId")
      .lean()
      .exec();

    const sortedUserContests = userContests.sort((a, b) => {
      if (a.score !== b.score) {
        return b.score - a.score;
      } else {
        return new Date(a.finishedAt).getTime() - new Date(b.finishedAt).getTime();
      }
    });

    let rank = 1;
    let prevScore = sortedUserContests[0]?.score ?? 0;
    let prevFinishedAt = new Date(sortedUserContests[0]?.finishedAt) ?? new Date();

    const populatedUserContests = sortedUserContests.map(userContest => {
      if (userContest.score !== prevScore || new Date(userContest.finishedAt).getTime() !== prevFinishedAt.getTime()) {
        rank++;
      }


      prevScore = userContest.score;
      prevFinishedAt = new Date(userContest.finishedAt);

      return {...userContest, rank};
    }).map(async (userContest, index) => {
      const user:any = await User.findById(userContest.userId)
        .select("_id email_phone firstName lastName department avatar")
        .populate({
          path: 'avatar',
          select: 'imageAddress',
        })
        .lean()
        .exec();

      return {
        ...userContest,
        userId: {
          ...user,
          avatar: user?.avatar?.imageAddress ?? null,
        },
      };
    });

    const populatedUserContestsResolved = await Promise.all(populatedUserContests);

    const userRank = populatedUserContestsResolved.findIndex(contest => contest.userId._id.toString() === userId) + 1;

    const userRankObject = userRank !== 0 ? { rank: userRank, userDetail: populatedUserContestsResolved[userRank - 1] } : null;

    baseResponse.success = true;
    baseResponse.message = 'Contest ranking retrieved successfully!';
    baseResponse.data = {
      rankings: populatedUserContestsResolved || [],
      userRank: userRankObject
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};


const populateContestCoin= async (req: Request, res: Response, next: NextFunction)=> {
  try{
    const contestId= req.params.id
    let baseResponse = new BaseResponse();

    const currentTime = new Date();

    const foundContest = await Contest.findOne({ _id: contestId }).lean().exec();
    
    if (!foundContest) {
      throw new Error("No contest found with that Id.");
    }

    if (currentTime < foundContest.startsAt) {
      baseResponse.success = true;
      baseResponse.message = 'Contest is upcoming, no ranking available.';
      baseResponse.data = {
        rankings: [],
        userRank: null,
      };
      return res.status(200).json({ ...baseResponse });
    }

    const contestPrize: any= await ContestPrize.findOne({contestId}).populate('prizeIds')

    if (!contestPrize){
      throw Error('no contest prize created for this contest!')
    }
    
    if (contestPrize.prizeIds[0].type !=='cash' && contestPrize.prizeIds[0].type !== 'coin'){
      throw Error('the type of the reward is not money or coin')
    }

    let totalPoint= 0
    const contestCategories= await ContestCategory.find({contestId})

    const categroyPromise= contestCategories.map(async (constesCategory)=> {
      const categoryCnt= await ContestQuestion.find({contestCategoryId: constesCategory._id}).countDocuments()
      totalPoint += categoryCnt
      return true 
    })

    const categories = await Promise.all(categroyPromise);
    const userContests = await UserContest.find({ contestId })
      .select("_id startedAt finishedAt score type contestId userId")
      .lean()
      .exec();

    const sortedUserContests = userContests.sort((a, b) => {
      if (a.score !== b.score) {
        return b.score - a.score;
      } else {
        return new Date(a.finishedAt).getTime() - new Date(b.finishedAt).getTime();
      }
    });

    let rank = 1;
    let prevScore = sortedUserContests[0]?.score ?? 0;
    let prevFinishedAt = new Date(sortedUserContests[0]?.finishedAt) ?? new Date();

    const populatedUserContests = sortedUserContests.map(userContest => {
      if (userContest.score !== prevScore || new Date(userContest.finishedAt).getTime() !== prevFinishedAt.getTime()) {
        rank+= 1;
      }


      prevScore = userContest.score;
      prevFinishedAt = new Date(userContest.finishedAt);

      return {...userContest, rank};
    }).map(async (userContest, index) =>{
      if (contestPrize){
        let coin: any;
        if (index < 3){
          
          const prize: any= contestPrize.prizeIds.filter((prize: any) => {
            return index +1 == parseInt(prize.standing)
          })
          coin= prize[0].amount
          await updateCoinIncentivization(userContest.userId.toString(), prize[0].amount, 'contest')
        }else{
          const coinGiven= parseInt(configs.CONTEST_COIN)
          coin= (Math.floor((coinGiven/ totalPoint)* userContest.score)).toString()
          await updateCoinIncentivization(userContest.userId.toString(), coin, 'contest')
        }
        return {...userContest, coin}
      }else{
        return {...userContest, coin: 0}
      }
    })
    const populatedUserContestsResolved = await Promise.all(populatedUserContests);
    baseResponse.success = true;
    baseResponse.message = 'Contest ranking retrieved successfully!';
    baseResponse.data = {
      rankings: populatedUserContestsResolved 
    };



    return res.status(200).json({ ...baseResponse });
  }catch(error){
    next(error)
  }
}

const contestController = { createContest, getContests, getContest, updateContest, deleteContest, getPreviousContests, getContestDetails, getContestRanking, populateContestCoin };

export default contestController
