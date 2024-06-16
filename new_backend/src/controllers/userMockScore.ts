import { Request, Response, NextFunction } from 'express';
import UserMockScore from '../models/userMockScore';
import Mock from '../models/mock';
import { userMockScoreValidator } from '../validations/joiModelValidator';
import { logUserDailyActivity, normalizeScore, updateUserPoint } from '../services/helpers';
import { Subject, UserScoreTracker } from '../types/typeEnum';
import { BaseResponse } from '../types/baseResponse';
import mongoose from 'mongoose';

const createUserMockScore = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const userId = req.body.user._id.toString();

    const { mockId, score } = req.body;

    const userInput = { userId, mockId, score };

    const { error, value } = userMockScoreValidator(userInput, 'post');

    if (error) throw error;

    const foundMock = await Mock.findOne({ _id: mockId });

    if (!foundMock) {
      throw new Error('No mock found with that ID');
    }

    if (score > foundMock.questions.length) {
        throw new Error('Score cannot be greater than the number of questions in the mock.');
    }

    const foundUserMockScore = await UserMockScore.findOne({ userId, mockId }).lean().exec()

    const prevScore = foundUserMockScore ? foundUserMockScore.score as number : 0;


    const filter = { userId, mockId };
    const update = { $set: { score }, $setOnInsert: { createdAt: new Date() } };
    const options = { upsert: true, new: true, setDefaultsOnInsert: true };

    const savedUserMockScore = await UserMockScore.findOneAndUpdate(filter, update, options);
    const dailyActivitySuccess= await logUserDailyActivity(userId, new Date(), 'mock')

    const userScoreUpdate = new UserScoreTracker()
    userScoreUpdate.previousScore = normalizeScore(prevScore, 10, foundMock.questions.length)
    userScoreUpdate.currentScore = normalizeScore(score, 10, foundMock.questions.length)

    await updateUserPoint(userId, userScoreUpdate);

    const baseResponse = {
      success: true,
      message: 'User Mock Score created/updated successfully!',
      data: {
        newUserMockScore: savedUserMockScore,
      },
    };

    return res.status(201).json(baseResponse);
  } catch (error) {
    next(error);
  }
};

const userMockRank = async (req: Request, res: Response, next: NextFunction) => {
  try {
      const { mockId } = req.params;
      const userId = req.body.user._id.toString();

      const scores = await UserMockScore.aggregate([
        { $match: { mockId: new mongoose.Types.ObjectId(mockId) } },
        { $sort: { score: -1 } },
        {
            $lookup: {
                from: "users",
                localField: "userId",
                foreignField: "_id",
                as: "user"
            }
        },
        {
          $lookup: {
              from: "mocks",
              localField: "mockId",
              foreignField: "_id",
              as: "mock"
          }
      },
        { $unwind: "$user" },
        { $unwind: { path: "$mock"} },
        {
            $lookup: {
                from: "images",
                let: { avatarId: "$user.avatar" },
                pipeline: [
                    {
                        $match: {
                            $expr: {
                                $eq: ["$_id", "$$avatarId"]
                            }
                        }
                    },
                    {
                        $project: {
                            _id: 0,
                            imageAddress: 1
                        }
                    }
                ],
                as: "avatar"
            }
        },
        {
            $project: {
                _id: 0,
                rank: 1, 
                userId: "$userId",
                score: "$score",
                completed: "$completed" || false,
                subject: "$mock.subject" || "",
                user: {
                    _id: "$user._id",
                    email_phone: "$user.email_phone",
                    firstName: "$user.firstName",
                    lastName: "$user.lastName",
                    department: "$user.department",
                    avatar: {
                        $cond: {
                            if: { $eq: [{ $size: "$avatar" }, 0] },
                            then: null,
                            else: { $arrayElemAt: ["$avatar.imageAddress", 0] }
                        }
                    }
                }
            }
        },
        {
            $addFields: {
                avatar: {
                    $cond: {
                        if: { $eq: ["$user.avatar", null] },
                        then: null,
                        else: "$avatar"
                    }
                }
            }
        }
    ]);

    const mock = await Mock.findById(mockId)
      let rank = 1;
      let prevScore = null;
      scores.forEach((scoreDoc: any, index: number) => {
        const score: number = scoreDoc.score;

        if (prevScore !== null && score < prevScore) {
            rank = index + 1;
        }
        scoreDoc.rank = rank;
        prevScore = score;
    });

    const userRanking= scores.filter(score=> score.user._id.toString() === userId)
      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Ranks calculated successfully!';
      baseResponse.data = {
        rankings: scores,
        userRank: userRanking.length > 0? userRanking[0] : null,
        mock: mock
      };

      return res.status(200).json({ ...baseResponse });
  } catch (error) {
      next(error);
  }
};

const userMockScoreController = { createUserMockScore, userMockRank};
export default userMockScoreController;