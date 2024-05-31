import { Request, Response, NextFunction } from 'express';
import UserMock from '../models/userMock';
import { userMockValidator } from '../validations/joiModelValidator';
import { BaseResponse } from '../types/baseResponse';
import User from '../models/user';
import Course from '../models/mock';
import Mock from '../models/mock';
import UserMockScore from '../models/userMockScore';
import QuestionUserAnswer from '../models/questionUserAnswer';

const getUserMocks = async (req, res, next) => {
    try {
      const userId = req.body.user._id.toString();

  
      const userMocks = await UserMock.findOne({ userId }).lean().exec();
      let baseResponse = new BaseResponse();
      if (!userMocks) {
        baseResponse.success = true;
        baseResponse.message = 'UserMocks retrieved successfully!';
        baseResponse.data = {
          allUserMocks: []
        };
        return res.status(200).json({ ...baseResponse });
      }
      
      const mockIds = userMocks.mocks.map((mockId) => mockId.toString());


      const mockPromises = mockIds.map((mockId) =>
            Mock.findOne({ _id: mockId })
                    .select("_id name questions departmentId")
                    .lean()
                    .exec()
                    .then((mock) => ({
                        _id: mock._id,
                        name: mock.name,
                        questions: mock.questions.length,
                        departmentId: mock.departmentId,
                    }))
            );

      const populatedMocks = await Promise.all(mockPromises);
      const userMockScores = await UserMockScore.find({ userId, mockId: { $in: mockIds } }).lean();
  
      const allUserMocks = userMocks.mocks.map((mockId:any, index:number) => {
        const matchedScore = userMockScores.find((score) => score.mockId.toString() === mockId.toString());

        return {
          mock: populatedMocks[index],
          completed: matchedScore && matchedScore.completed != null? matchedScore.completed : false,
          score: matchedScore ? matchedScore.score : 0,
        };
      });
  
      baseResponse.success = true;
      baseResponse.message = "User mocks retrieved successfully!";
      baseResponse.data = {
        allUserMocks,
      };
  
      return res.status(200).json({ ...baseResponse });
    } catch (error) {
      console.log(error)
      next(error);
    }
  };
  

const addMockToUserMocks = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { user, mock } = req.body;
      const foundMock = await Mock.findById(mock);
      if (!foundMock) {
        throw new Error("Mock does not exist");
      }
  
      let userMockToBeUpdated = await UserMock.findOne({ userId: user._id });
  
      if (!userMockToBeUpdated) {
        userMockToBeUpdated = new UserMock({
          userId: user._id,
          mocks: [mock],
        });
        await userMockToBeUpdated.save();
      } else {
        const mockExists = userMockToBeUpdated.mocks.includes(mock);
        if (!mockExists) {
          userMockToBeUpdated.mocks.push(mock);
          await userMockToBeUpdated.save();
        }
      }

      const baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = "Mock added to user successfully!";
      baseResponse.data = {
        userMockToBeUpdated,
      };
  
      return res.status(200).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };


  const removeMockFromUserMocks = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { mock, user } = req.body;
  
      const foundUserMock = await UserMock.findOne({ userId: user._id.toString() });
      if (!foundUserMock) {
        throw new Error("User mock does not exist.");
      } else if (!foundUserMock.mocks.includes(mock)) {
        throw new Error("Mock does not exist in the user mocks");
      } else {
        const userMockToBeUpdated = await UserMock.findOneAndUpdate(
          { userId: user._id.toString() },
          { $pull: { mocks: mock } },
          { new: true }
        ).lean().exec();
  
        const baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'Mock removed from user mocks successfully!';
        baseResponse.data = {
            userMockToBeUpdated,
        };
  
        return res.status(200).json({ ...baseResponse });
      }
    } catch (error) {
      next(error);
    }
  };

  const retakeMock = async (req: Request, res: Response, next: NextFunction) => {
    try {

      const userId = req.body.user._id.toString();
      const mockId= req.params.id

      const updateScoreQuery = {
        $set: { completed: false, score: 0 }
      };
  
      const userMockScore = await UserMockScore.findOneAndUpdate(
        { mockId, userId },
        updateScoreQuery,
        { new: true, upsert: true }
      ).lean().exec();
  
      if (!userMockScore) {
        throw Error('UserMockScore not found or created.');
      }
  
      const mock = await Mock.findOne({ _id: mockId }).lean().exec();
      const questionIds = mock.questions;
  
      for (const questionId of questionIds) {
        await QuestionUserAnswer.findOneAndUpdate(
          { questionId, userId },
          { $set: { userAnswer: "choice_E" } },
          { upsert: true }
        );
      }

      const baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'Mock score from user mocks successfully!';
        baseResponse.data = {
          userMockScore,
        };
  
        return res.status(200).json({ ...baseResponse });
    } catch (error) {
      throw error;
    }
  };

const UserMockControllers = {getUserMocks, addMockToUserMocks, removeMockFromUserMocks, retakeMock}

export default UserMockControllers