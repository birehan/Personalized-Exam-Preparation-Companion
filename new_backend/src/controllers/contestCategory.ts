import { Request, Response, NextFunction } from 'express';
import ContestCategory, { IContestCategoryDocument } from '../models/contestCategory';
import { contestCategoryValidation } from '../validations/joiModelValidator';
import ContestQuestion from '../models/contestQuestion';
import { BaseResponse } from '../types/baseResponse';
import UserContest from '../models/userContest';
import UserContestCategory from '../models/userContestCategory';
import { QuestionAnswers } from '../models/questionUserAnswer';
import UserContestQuestionAnswer from '../models/userContestQuestionAnswer';
import Contest from '../models/contest';
import { hasContestEnded, logUserDailyActivity, normalizeScore, updateUserPoint } from '../services/helpers';
import UserDailyActivity from '../dashboard/models/userDailyActivity';
import { UserScoreTracker } from '../types/typeEnum';

const createContestCategory = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { title, subject, contestId } = req.body;

    const userInput = { title, subject, contestId };

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

const getContestCategories = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const contestCategories = await ContestCategory.find().lean().exec();
    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Contest Categories retrieved successfully!';
    baseResponse.data = {
      contestCategories,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getContestCategory = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const id = req.params.id;
    const contestCategory = await ContestCategory.findOne({ _id: id }).lean().exec();

    if (!contestCategory) throw Error('Contest Category not found with that Id.');

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Contest Category retrieved successfully!';
    baseResponse.data = {
      contestCategory,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const updateContestCategory = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const contestCategoryToBeUpdated = await ContestCategory.findById(id).lean().exec();

    if (!contestCategoryToBeUpdated) throw Error('Contest Category not found with that Id.');

    const { title, subject, contestId } = req.body;

    let updateObject = { title, subject, contestId };

    for (const key in updateObject) {
      if (!updateObject[key]) delete updateObject[key];
    }

    const { error, value } = contestCategoryValidation(updateObject, 'put');

    if (error) throw error;

    const updatedContestCategory = await ContestCategory.findByIdAndUpdate(id, value, { new: true }).lean().exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Contest Category updated successfully!';
    baseResponse.data = {
      updatedContestCategory,
    };
    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const deleteContestCategory = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const contestCategoryToBeDeleted = await ContestCategory.findById(id).lean().exec();

    if (!contestCategoryToBeDeleted) throw Error('Contest Category not found with that Id.');

    const deletedContestCategory = await ContestCategory.findByIdAndDelete(id).lean().exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Contest Category deleted successfully!';
    baseResponse.data = {
      deletedContestCategory,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getContestCategoryQuestions = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const contestCategoryId = req.params.id;
    const userId = req.body.user._id;
    const baseResponse = new BaseResponse();

    const foundContestCategory = await ContestCategory.findOne({_id: contestCategoryId}).lean().exec();

    if(!foundContestCategory){
      throw Error("No contest category with that ID!");
    }

    const currentDate = new Date();

    const foundContest = await Contest.findOne({ _id: foundContestCategory.contestId })
      .lean()
      .exec();

    const hasRegistered =  await UserContest.exists({ userId, contestId:  foundContest._id}) ? true : false;
    const hasEnded = hasRegistered ? await hasContestEnded(foundContest._id, userId, currentDate) : false;
    const userContest = await UserContest.findOne({userId, contestId:foundContest._id}).lean().exec();
    const isLive = hasRegistered ? currentDate.getTime() >= userContest.startedAt.getTime() && currentDate.getTime() <= (userContest.startedAt.getTime() + (foundContest.endsAt.getTime() - foundContest.startsAt.getTime())): false;

    if(!isLive && !hasEnded){
      throw Error("Contest hasn't started yet!")
    }

    const contestQuestions = await ContestQuestion.find({
      contestCategoryId,
    }).select('-answer -explanation').lean().exec();

    if (!contestQuestions || contestQuestions.length === 0) {
      baseResponse.success = true;
      baseResponse.data = {questions: []}
      baseResponse.message = 'No questions found for the specified contest category.';
      return res.status(200).json({ ...baseResponse });
    }

    baseResponse.success = true;
    baseResponse.message = 'Contest category questions retrieved successfully!';
    baseResponse.data = {
      questions: contestQuestions,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};


const userCategorySubmitQuestions = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { contestCategory, userAnswer } = req.body;
    const userId = req.body.user._id.toString();

    const baseResponse = new BaseResponse();

    if (!userAnswer || !Array.isArray(userAnswer) || userAnswer.length === 0) {
      throw Error('Invalid userAnswer provided.');
    }

    const contestQuestionIds = userAnswer.map((item: any) => item.contestQuestionId);

    const category = await ContestCategory.findOne({_id: contestCategory }).lean().exec();

    if (!category) {
      throw Error('No category found with that ID!');
    }

    const contestCategoryId = category._id;

    const questionsBelongToCategory = await ContestQuestion.find({
      _id: { $in: contestQuestionIds },
      contestCategoryId: contestCategoryId,
    }).countDocuments();

    if (questionsBelongToCategory !== userAnswer.length) {
      throw Error('All questions should belong to the same category.');
    }

    const foundCategory= await ContestCategory.findOne({ _id: contestCategoryId }).lean().exec();

    if (!foundCategory) {
      throw Error('Contest category does not exist.');
    }

    const foundContest = await Contest.findOne({_id: foundCategory.contestId}).lean().exec();

    if (!foundContest) {
      throw Error('Contest does not exist for this category.');
    }

    const userRegistered = await UserContest.findOne({ userId, contestId:  foundContest._id}).lean().exec();

    if (!userRegistered) {
      throw Error('User is not registered to this contest.');
    }

    const userContestCategory = await UserContestCategory.findOne({ userId, _id: foundCategory._id }).lean().exec();

    if (userContestCategory && userContestCategory.isSubmitted === true) {
      throw Error('User answer submitted already.')
    }

    const contestQuestions = await ContestQuestion.find({ _id: { $in: contestQuestionIds } }).lean().exec();

    const validUserAnswer = userAnswer.every((item: any) => Object.values(QuestionAnswers).includes(item.userAnswer));

    if (!validUserAnswer) {
      throw Error('Invalid userAnswer values.')
    }

    const currentTime = new Date();
    const contestEndTime = new Date(userRegistered.startedAt.getTime() + (foundContest.endsAt.getTime() - foundContest.startsAt.getTime()));

    if (!(currentTime >= userRegistered.startedAt && currentTime <= contestEndTime)) {
      throw Error('Contest has ended or not started yet.');
    }

    // Scoring the user based on the userAnswer
    let score = 0;

    contestQuestions.forEach((question) => {
      const matchingAnswer = userAnswer.find((item: any) => item.contestQuestionId.toString() === question._id.toString());

      if (matchingAnswer && matchingAnswer.userAnswer === question.answer) {
        score++;
      }

      const userContestQuestionAnswer = new UserContestQuestionAnswer({
        contestQuestionId: question._id,
        userId,
        userAnswer: matchingAnswer ? matchingAnswer.userAnswer : '',
      });

      userContestQuestionAnswer.save();
    });

      const newUserContestCategory = new UserContestCategory({
        contestCategoryId,
        userId,
        score,
        isSubmitted: true,
      });

      newUserContestCategory.save();

      const updateContestScore = await UserContest.findByIdAndUpdate(userRegistered._id, {
        $set: { 
          score: userRegistered.score + score,
          finishedAt: currentTime,
        },
      });

      const Today = new Date();
      Today.setUTCHours(0, 0, 0, 0);

      const todaysContest = await Contest.aggregate([
        {
          $match: {
            startsAt: {
              $gte: Today,
              $lt: new Date(Today.getTime() + 24 * 60 * 60 * 1000),
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

      if(todaysContest.length > 0 && todaysContest[0]._id.toString() === foundContest._id.toString()){
        const foundUserDailyQuest = await UserDailyActivity.findOne({ userId, day: Today}).lean().exec();
        if(!foundUserDailyQuest || !foundUserDailyQuest.contestCompleted || foundUserDailyQuest.contestCompleted === 0){ 
          await logUserDailyActivity(userId, Today, 'contest')
        }
      }

      if(userRegistered.type === 'live'){
        const userScoreUpdate = new UserScoreTracker();
        const contestCategoryCount = await ContestCategory.countDocuments({ contestId: userRegistered.contestId }).lean().exec();
        const questionCount = await ContestQuestion.countDocuments({ contestCategoryId });

        userScoreUpdate.previousScore = normalizeScore(0, 10/contestCategoryCount, questionCount)
        userScoreUpdate.currentScore = normalizeScore(score, 10/contestCategoryCount, questionCount)

        await updateUserPoint(userId, userScoreUpdate);
      }

      baseResponse.success = true;
      baseResponse.message = 'User answers submitted successfully!';
      return res.status(200).json({ ...baseResponse });
      
  } catch (error) {
    next(error);
  }
};

const getContestCategoryAnalysis = async ( req: Request, res: Response, next: NextFunction ) => {
  try {
    const contestCategoryId = req.params.id;
    const userId = req.body.user._id;
    const baseResponse = new BaseResponse();

    const foundContestCategory = await ContestCategory.findOne({ _id: contestCategoryId })
      .lean()
      .exec();

    if (!foundContestCategory) {
      throw Error('No contest category with that ID!');
    }

    const currentDate = new Date();

    const foundContest = await Contest.findOne({ _id: foundContestCategory.contestId })
      .lean()
      .exec();

    const userContest = await UserContest.findOne({ userId, contestId: foundContest._id }).lean().exec();

    if (!userContest) {
      throw Error(`Work on the contest first! Contest hasn't been started yet `);
    }

    const hasEnded = userContest ? await hasContestEnded(foundContest._id, userId, currentDate) : false;

    if (!hasEnded) {
      throw Error("Contest hasn't ended yet!");
    }

    const contestQuestions = await ContestQuestion.find({
      contestCategoryId,
    })
      .lean()
      .exec();

    if (!contestQuestions || contestQuestions.length === 0) {
      baseResponse.success = true;
      baseResponse.data = { questions: [] };
      baseResponse.message = 'No questions found for the specified contest category.';
      return res.status(200).json({ ...baseResponse });
    }

    const questionsUserAnsPromises = contestQuestions.map(async (question: any) => {
      const questionId = question._id;
      const userQuestionAnswer = await UserContestQuestionAnswer.findOne({
        userId,
        contestQuestionId: questionId,
      })
        .select('userId contestQuestionId userAnswer -_id')
        .lean()
        .exec();
      return userQuestionAnswer || {
        userId,
        contestQuestionId: questionId,
        userAnswer: QuestionAnswers.E,
      };
    });

    const questionsUserAnsResults = await Promise.all(questionsUserAnsPromises);

    const questionsWithUserAns = contestQuestions.map((question: any, index: number) => {
      const userAnswer = questionsUserAnsResults[index];
      return {
        question: { ...question, isLiked: false },
        userAnswer: userAnswer,
      };
    });

    baseResponse.success = true;
    baseResponse.message = 'Contest category questions retrieved successfully!';
    baseResponse.data = {
      questions: questionsWithUserAns,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const contestCategoryController = {
  createContestCategory,
  getContestCategories,
  getContestCategory,
  updateContestCategory,
  deleteContestCategory,
  getContestCategoryQuestions,
  userCategorySubmitQuestions,
  getContestCategoryAnalysis
};

export default contestCategoryController;
