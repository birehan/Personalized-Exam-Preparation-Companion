import { Request, Response, NextFunction } from 'express';
import { BaseResponse } from '../types/baseResponse';
import UserChapterAnalysis from '../models/userChapterAnalysis';
import { userChapterAnalysisValidator } from '../validations/joiModelValidator';
import Chapter from '../models/chapter';
import SubChapter from '../models/subChapter';
import UserCourseAnalysisControllers from './userCourseAnalysis';
import UserCourseAnalysis from '../models/userCourseAnalysis';
import { logTotalChapterCompleted, logTotalTopicCompleted, logUserDailyActivity } from '../services/helpers';
import Course from '../models/course';
import { ObjectId } from "mongodb"
import UserVideoAnalysis from '../models/userVideoAnalysis';
import VideoContent from '../models/videoContent';

const addSubchapter = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const userId = req.body.user._id.toString();
        const departmentId = req.body.user.department.toString();
        const { chapterId, subChapterId } = req.body;
    
        const userInput = {
            userId,
            chapterId,
            completedSubChapters: [subChapterId]
        };
    
        const { error, value } = userChapterAnalysisValidator(userInput, 'post');
    
        if (error) {
            throw error;
        }
    
        const foundChapter = await Chapter.findOne({ _id: chapterId }).lean().exec();
    
        if (!foundChapter) {
            throw Error('Chapter not found with ID.');
        }
        const foundCourse = await Course.findOne({ _id: foundChapter.courseId }).lean().exec();
    
        const foundSubChapter = await SubChapter.findOne({ _id: subChapterId }).lean().exec();
    
        if (!foundSubChapter) {
            throw Error('Sub chapter not found with ID.');
        }

        if(foundSubChapter.chapterId.toString() !== chapterId ) throw Error("This subchapter doesn't belong to the provided chapter.");
    
        const updateQuery = {
            $addToSet: { completedSubChapters: subChapterId }
        };
    
        const options = {
            new: true,
            upsert: true
        };
    
        const updatedUserChapterAnalysis = await UserChapterAnalysis.findOneAndUpdate(
            { userId: userId, chapterId: chapterId },
            updateQuery,
            options
        ).lean().exec();

        const userChapterAnalysis = await UserChapterAnalysis.findOne({ userId: userId, chapterId: chapterId }).lean().exec();
        const chapterSubChapters = await SubChapter.find({chapterId,}).lean().exec();
        let savedCourseAnalysis;

        if(userChapterAnalysis.completedSubChapters.length === chapterSubChapters.length) {
            let chapterIdObj =  new ObjectId(chapterId)
            savedCourseAnalysis = await UserCourseAnalysisControllers.addChapter({ userId, courseId: foundChapter.courseId.toString(), chapterId: chapterIdObj.toString(), departmentId});
        }

        const dailyActivitySuccess= await logUserDailyActivity(userId, new Date(), 'subchapter')
        const success = await logTotalTopicCompleted(departmentId, foundCourse.name, new Date());
        
        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'Subchapter added successfully!';
        baseResponse.data = {
            userChapterAnalysis: updatedUserChapterAnalysis,
            savedCourseAnalysis: savedCourseAnalysis,
        };
    
        return res.status(200).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };

  const removeSubChapter = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const userId = req.body.user._id.toString();

        const { chapterId, subChapterId } = req.body;

        const userChapterAnalysis = await UserChapterAnalysis.findOne({ userId: userId, chapterId: chapterId }).lean().exec();
        if (!userChapterAnalysis) {
            throw new Error('No Chapter analysis found.');
        }
    
        if (!userChapterAnalysis.completedSubChapters.map((id) => id.toString()).includes(subChapterId)) {
            throw new Error('Sub chapter not found in completed subChapters.');
        }
    
        const updatedUserChapterAnalysis = await UserChapterAnalysis.findOneAndUpdate(
            { userId: userId, chapterId: chapterId },
            { $pull: { completedSubChapters: subChapterId } },
            { new: true }
        ).lean().exec();

        const foundChapter = await Chapter.findOne({ _id: chapterId }).lean().exec();
        const userCourseAnalysis = await UserCourseAnalysis.findOne({ userId, courseId:foundChapter.courseId }).lean().exec();
        let removedCourseAnalysis;

        if (userCourseAnalysis) {
            if (userCourseAnalysis.completedChapters.map((id) => id.toString()).includes(chapterId)) {
                removedCourseAnalysis = await UserCourseAnalysisControllers.removeChapter({ userId, courseId: foundChapter.courseId.toString(), chapterId,});
            }
        }
    
        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'Subchapter removed successfully!';
        baseResponse.data = {
            userChapterAnalysis: updatedUserChapterAnalysis,
            removedCourseAnalysis: removedCourseAnalysis
        };
    
        return res.status(200).json({ ...baseResponse });
        } catch (error) {
        next(error);
        }
    };

    const updateUserVideoAnalysis = async (req: Request, res: Response, next: NextFunction) => {
        try {
            const userId = req.body.user._id.toString();
            const { videoId, completed } = req.body;
    
            if (!videoId) {
                throw Error('Video Id is required!')
            }
            const foundVideo = await VideoContent.findById(videoId).lean().exec();
            if (!foundVideo) {
                throw Error('Wrong video id!')
            }
            let baseResponse = new BaseResponse();
        
            if (completed){
                const activity= await logUserDailyActivity(userId, new Date(), 'video');
            }
            const existingAnalysis = await UserVideoAnalysis.findOne({ userId, videoId }).lean().exec();
            if (existingAnalysis) {
                if (completed !== undefined) {
                    
                    const updatedAnalysis= await UserVideoAnalysis.findOneAndUpdate({ userId, videoId }, { completed }, { new: true }).exec();
                    baseResponse.success = true;
                    baseResponse.message = 'user video updated successfully!';
                    baseResponse.data = {
                        userVideo: updatedAnalysis
                    };
                    return res.status(200).json({ ...baseResponse });
                }
                baseResponse.success = true;
                baseResponse.message = 'existing user Video!';
                baseResponse.data = {
                    userVideo: existingAnalysis
                };
                return res.status(200).json({ ...baseResponse });
            }
    
            const userInput = {
                userId,
                videoId,
                completed: completed || false 
            };
    
            const newUserVideoAnalysis = new UserVideoAnalysis(userInput);
            await newUserVideoAnalysis.save();
            baseResponse.success = true;
            baseResponse.message = 'user video updated successfully!';
            baseResponse.data = {
                userVideo: newUserVideoAnalysis
            };
            return res.status(200).json({ ...baseResponse });
        } catch (error) {
            next(error);
        }
    }


const userChapterAnalysisControllers = { addSubchapter, removeSubChapter, updateUserVideoAnalysis }

export default userChapterAnalysisControllers
