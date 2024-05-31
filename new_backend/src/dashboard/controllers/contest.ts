import { Request, Response, NextFunction } from "express";
import { contestCategoryValidation, contestPrizeValidation, contestQuestionValidation, contestValidation, prizeValidation } from "../../validations/joiModelValidator";
import Department from "../../models/department";
import Contest, { IContestDocument } from "../../models/contest";
import { BaseResponse } from "../../types/baseResponse";
import ContestPrize from "../../models/contestPrize";
import ContestCategory from "../../models/contestCategory";
import ContestQuestion from "../../models/contestQuestion";
import UserContest from "../../models/userContest";
import { categorizeCourse } from "../../services/helpers";
import User from "../../models/user";
import { Types } from "mongoose";
import Prize, { IPrizeDocument } from "../../models/prize";
import Question, { IQuestion } from "../../models/question";

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

const getPreviousContests = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const currentDate = new Date();
        let baseResponse = new BaseResponse();

        const previousContests = await Contest.find({
        endsAt: { $lt: currentDate },
        startsAt: { $lte: currentDate },
        })
        .populate('departmentId', 'name')
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

const getLiveContests = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const currentDate = new Date();
        let baseResponse = new BaseResponse();

        const previousContests = await Contest.find({
        endsAt: { $gte: currentDate },
        startsAt: { $lt: currentDate },
        })
        .populate('departmentId', 'name')
        .sort({ endsAt: -1 })
        .lean()
        .exec();

        if (!previousContests || previousContests.length === 0) {
        baseResponse.success = true;
        baseResponse.data = {contests: []}
        baseResponse.message = 'No Live contests found!';
        return res.status(200).json({ ...baseResponse });
        }

        baseResponse.success = true;
        baseResponse.message = 'Live contests retrieved successfully!';
        baseResponse.data = {
        contests: previousContests,
        };

        return res.status(200).json({ ...baseResponse });
    } catch (error) {
        next(error);
    }
};

const getUpComingContests = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const currentDate = new Date();
        let baseResponse = new BaseResponse();

        const previousContests = await Contest.find({
        endsAt: { $gt: currentDate },
        startsAt: { $gt: currentDate },
        })
        .populate('departmentId', 'name')
        .sort({ startsAt: 1 })
        .lean()
        .exec();

        if (!previousContests || previousContests.length === 0) {
        baseResponse.success = true;
        baseResponse.data = {contests: []}
        baseResponse.message = 'No Upcoming contests found!';
        return res.status(200).json({ ...baseResponse });
        }

        baseResponse.success = true;
        baseResponse.message = 'Upcoming contests retrieved successfully!';
        baseResponse.data = {
        contests: previousContests,
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
  
      await UserContest.updateMany(
        { contestId: id },
        { $set: { startedAt: updatedContest.startsAt, finishedAt: updatedContest.endsAt } }
      );

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


  const getContestDetails = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { id } = req.params;
  
      const contest = await Contest.findById(id).lean().exec();
  
      if (!contest) {
        throw Error('Contest not found with that ID.');
      }
  
      const contestCategories = await ContestCategory.find({ contestId: id }).lean().exec();
  
      const contestPrizes = await ContestPrize.findOne({ contestId: id })
        .populate('prizeIds') 
        .lean()
        .exec();
  
      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Contest details fetched successfully!';
      baseResponse.data = {
        contest,
        contestCategories,
        contestPrizes,
      };
  
      return res.status(200).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };

  const getContestQuestionsByCategoryId = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { id } = req.params;
  
      const contestQuestions = await ContestQuestion.find({ contestCategoryId: id }).lean().exec();
  
      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Contest questions fetched successfully!';
      baseResponse.data = {
        contestQuestions,
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
  
  const createContestCategory = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { title, subject, contestId } = req.body;

      const existingContest = await Contest.findById(contestId).exec();
      if (!existingContest) {
        throw new Error('Invalid contestId. Contest not found.');
      }
  
      const categorizedSubject = categorizeCourse(subject);

      const userInput = { title, subject: categorizedSubject, contestId };
  
      const { error, value } = contestCategoryValidation(userInput, 'post');
  
      if (error) throw error;
  
      const contestCategory = new ContestCategory({ ...value });
  
      const savedContestCategory = await contestCategory.save();
  
      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Contest Category created successfully!';
      baseResponse.data = {
        newContestCategory: savedContestCategory,
      };
  
      return res.status(201).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };

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
        difficulty,
        questionId
      } = req.body;
  
      const existingContestCategory = await ContestCategory.findById(contestCategoryId).exec();
      if (!existingContestCategory) {
        throw new Error('Invalid contestCategoryId. ContestCategory not found.');
      }
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
        difficulty,
        questionId
      };
  
      const { error, value } = contestQuestionValidation(userInput, 'post');
  
      if (error) throw error;

      if (questionId){

        const foundQuestion = await ContestQuestion.findOne({questionId: questionId}).lean().exec()

        if (foundQuestion){
          throw Error("That question is already used before!")
        }
      }

  
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

  const getContestRanking = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const contestId = req.params.id;
      let baseResponse = new BaseResponse();
  
      const currentTime = new Date();
  
      const foundContest = await Contest.findOne({_id: contestId}).lean().exec();
  
      if(!foundContest) { throw Error("No contest found with that Id.")}
  
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
  
      const sortedUserContests = [...userContests].sort((a, b) => {
        if (a.score !== b.score) {
          return b.score - a.score;
        } else {
          return a.finishedAt.getTime() - b.finishedAt.getTime();
        }
      });
  
      const populatedUserContests = await Promise.all(
        sortedUserContests.map(async (userContest) => {
          const user: any = await User.findById(userContest.userId)
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
        })
      );
  
  
  
      baseResponse.success = true;
      baseResponse.message = 'Contest ranking retrieved successfully!';
      baseResponse.data = {
        rankings: populatedUserContests || [],
      };
  
      return res.status(200).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };

  const getRegisteredUsers = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const contestId = req.params.id;
      let baseResponse = new BaseResponse();
      const pipeline = [
        {
          $match: {
            contestId: new Types.ObjectId(contestId),
          },
        },
        {
          $lookup: {
            from: 'users',
            localField: 'userId',
            foreignField: '_id',
            as: 'user',
          },
        },
        {
          $unwind: '$user',
        },
        {
          $lookup: {
            from: 'images',
            localField: 'user.avatar',
            foreignField: '_id',
            as: 'user.avatar',
          },
        },
        {
          $unwind: {
            path: '$user.avatar',
            preserveNullAndEmptyArrays: true,
          },
        },
        {
          $group: {
            _id: '$user._id',
            firstName: { $first: '$user.firstName' },
            lastName: { $first: '$user.lastName' },
            email_phone: { $first: '$user.email_phone' },
            highSchool: { $first: '$user.highSchool' },
            grade: { $first: '$user.grade' },
            avatar: { $first: '$user.avatar' },
          },
        },
      ];
      
  
      const users = await UserContest.aggregate(pipeline).exec();
  
      baseResponse.success = true;
      baseResponse.message = 'Contest ranking retrieved successfully!';
      baseResponse.data = users;
  
      return res.status(200).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };

  const getPrizesByStanding = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const baseResponse = new BaseResponse();
  
      const pipeline= Prize.aggregate([
        {
          $group: {
            _id: '$standing',
            prizes: {
              $push: {
                _id: '$_id',
                description: '$description',
                type: '$type',
                amount: '$amount',
              },
            },
          },
        },
        {
          $sort: {
            _id: 1,
          },
        },
      ]);
  

      const prizesByStanding = await pipeline.exec();
  
      baseResponse.success = true;
      baseResponse.message = 'Prizes fetched successfully!';
      baseResponse.data = prizesByStanding;
  
      return res.status(200).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };

  const createPrize = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { standing, description, type, amount } = req.body;
      const userInput = { standing, description, type, amount };
  
      const { error, value } = prizeValidation(userInput, 'post');
      if (error) throw error;
  
      const prize = new Prize({ ...value });
      const savedPrize = await prize.save();
  
      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Prize created successfully!';
      baseResponse.data = {
        newPrize: savedPrize,
      };
  
      return res.status(201).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };

  const createContestPrize = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { prizeIds, contestId } = req.body;
      const userInput = { prizeIds, contestId };
  
      const { error, value } = contestPrizeValidation(userInput, 'post');
      if (error) throw error;
  
      const foundContestPrize = await ContestPrize.findOne({contestId,}).lean().exec();
  
      if (foundContestPrize){ throw Error("Prize already created for this contest! Try updating instead!")}
  
      const contestPrize = new ContestPrize({ ...value });
      const savedContestPrize = await contestPrize.save();
  
      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'ContestPrize created successfully!';
      baseResponse.data = {
        newContestPrize: savedContestPrize,
      };
  
      return res.status(201).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };

  const searchQuestions = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { search, subject, page = 1, limit = 10 } = req.query;

      const pipeline: any[] = [];

      if (subject) {
          const subjectRegex = new RegExp(subject as string, 'i');
          const subjectMatchStage: any = {
              $match: { subject: { $regex: subjectRegex } },
          };
          pipeline.push(subjectMatchStage);
      } 

      if (search && (search as string).trim() !== '') {
          const searchRegex = new RegExp(search as string, 'i');
          const searchMatchStage: any = {
              $match: {
                  $or: [
                      { description: { $regex: searchRegex } },
                      { choiceA: { $regex: searchRegex } },
                      { choiceB: { $regex: searchRegex } },
                      { choiceC: { $regex: searchRegex } },
                      { choiceD: { $regex: searchRegex } },
                      { answer: { $regex: searchRegex } },
                  ],
              },
          };
          pipeline.push(searchMatchStage);
      } 

      const countStage: any = { $count: 'totalDocuments' };
      const resultPipeline: any[] = [...pipeline, countStage];

      const countResult = await Question.aggregate(resultPipeline);
      const totalDocuments = countResult.length > 0 ? countResult[0].totalDocuments : 0;
      const totalPages = Math.ceil(totalDocuments / Number(limit));

      pipeline.push(
          { $skip: (Number(page) - 1) * Number(limit) },
          { $limit: Number(limit) },
      );

      const result: IQuestion[] = await Question.aggregate(pipeline);

        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'Questions retrieved successfully based on search!';
        baseResponse.data = {
            questions: result,
            page: Number(page),
            limit: Number(limit),
            totalPages,
            totalDocuments,
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

const deleteContest = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { contestId } = req.params;

    const contest = await Contest.findById(contestId);
    if (!contest) {
      throw Error("Contest not found")
    }

    if (contest.startsAt <= new Date()) {
      throw Error('Contest has already started')
    }


    const contestCategories = await ContestCategory.find({ contestId });
    const categoryIds = contestCategories.map(category => category._id);
    const deletedContestQuestion = await ContestQuestion.deleteMany({ contestCategoryId: { $in: categoryIds } });

    const deletedUserContests= await UserContest.deleteMany({ contestId });
    const deletedCategories= await ContestCategory.deleteMany({ contestId });


    const deteletedContest= await contest.remove();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Contest Question deleted successfully!';
    baseResponse.data = {
      deletedContestQuestion,
      deletedCategories,
      deletedUserContests,
      deteletedContest
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error)
  }
};


async function fetchAndMatchQuestions(req, res) {
  try {
      const contestQuestions = await ContestQuestion.find();

      for (const contestQuestion of contestQuestions) {
          let { description, choiceA, choiceB, choiceC, choiceD, explanation } = contestQuestion;
          if (contestQuestion.questionId) {
            console.log(`Skipping contest question with ID ${contestQuestion._id} because questionId is already defined.`);
            continue; 
        }
        const descriptionPattern = new RegExp(description.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&'), 'i');
            const choiceAPattern = new RegExp(choiceA.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&'), 'i');
            const choiceBPattern = new RegExp(choiceB.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&'), 'i');
            const choiceCPattern = new RegExp(choiceC.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&'), 'i');
            const choiceDPattern = new RegExp(choiceD.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&'), 'i');
            const explanationPattern = new RegExp(explanation.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&'), 'i');


          const matchedQuestion = await Question.findOne({
              $or: [
                  { description: descriptionPattern },
                  { choiceA: choiceAPattern },
                  { choiceB: choiceBPattern },
                  { choiceC: choiceCPattern },
                  { choiceD: choiceDPattern },
                  { explanation: explanationPattern }
              ]
          });
          if (matchedQuestion) {
                  contestQuestion.questionId = matchedQuestion._id;
                  await ContestQuestion.findByIdAndUpdate(contestQuestion._id, contestQuestion);
          }else{
            console.log(`question not found ${contestQuestion._id}`)
          }
              
      }

      return res.send("Contest questions matched successfully!");
  } catch (error) {
      return res.send("Error occurred while fetching and matching contest questions:", error);
  }
}
const contestController = { deleteContest, searchQuestions, fetchAndMatchQuestions, deleteContestQuestion, createContest, createPrize, createContestPrize, getPrizesByStanding, getRegisteredUsers, getContestRanking, createContestQuestion, updateContest, createContestCategory, updateContestQuestion, getContestQuestionsByCategoryId, getContestDetails, getPreviousContests, getLiveContests, getUpComingContests };


export default contestController

