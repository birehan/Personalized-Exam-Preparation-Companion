import UserCourseAnalysis from '../models/userCourseAnalysis';
import { userCourseAnalysisValidator } from '../validations/joiModelValidator';
import { BaseResponse } from '../types/baseResponse';
import Course from '../models/course';
import Chapter from '../models/chapter';
import { ObjectId } from 'mongodb';
import { UserScoreTracker } from '../types/typeEnum';
import { logTotalChapterCompleted, logUserDailyActivity, updateUserPoint } from '../services/helpers';

const addChapter = async (courseInfo) => {
    try {    
        const { userId, courseId, chapterId,departmentId} = courseInfo;
        const userInput = {
            userId,
            courseId,
            completedChapters: [chapterId]
        };
    
        const { error, value } = userCourseAnalysisValidator(userInput, 'post');
    
        if (error) {
            throw error;
        }
    
        const foundCourse = await Course.findOne({ _id: courseId }).lean().exec();
    
        if (!foundCourse) {
            throw Error('Course not found with that ID.');
        }
    
        const foundChapter = await Chapter.findOne({ _id: chapterId }).lean().exec();
    
        if (!foundChapter) {
            throw Error('chapter not found with that ID.');
        }
    
        const userChapterAnalysis = await UserCourseAnalysis.findOne({ userId: userId, courseId: courseId }).lean().exec();

        if(userChapterAnalysis){
            const chapterCompleted = userChapterAnalysis.completedChapters.includes(chapterId);

            if(chapterCompleted){
                return userChapterAnalysis
            }
        }

        const updateQuery = {
            $addToSet: { completedChapters: chapterId }
        };
    
        const options = {
            new: true,
            upsert: true
        };
    
        const updatedUserCourseAnalysis = await UserCourseAnalysis.findOneAndUpdate(
            { userId: userId, courseId: courseId },
            updateQuery,
            options
        ).lean().exec();

        const success = await logTotalChapterCompleted(departmentId, foundCourse.name, new Date());
        const dailyActivitySuccess= await logUserDailyActivity(userId, new Date(), 'chapter');

        const userScoreUpdate = new UserScoreTracker()
        userScoreUpdate.previousScore = 0
        userScoreUpdate.currentScore = 1

        await updateUserPoint(userId, userScoreUpdate);

        return updatedUserCourseAnalysis;
    } catch (error) {
      throw error;
    }
  };

  const removeChapter = async (courseInfo) => {
    try {
        const { userId, courseId, chapterId,} = courseInfo;

        const userCourseAnalysis = await UserCourseAnalysis.findOne({ userId, courseId, }).lean().exec();
        if (!userCourseAnalysis) {
            throw new Error('No Course analysis found.');
        }
    
        if (!userCourseAnalysis.completedChapters.map((id) => id.toString()).includes(chapterId)) {
            throw new Error('chapter not found in completed chapters.');
        }
    
        const updatedUserCourseAnalysis = await UserCourseAnalysis.findOneAndUpdate(
            { userId: userId, courseId: courseId },
            { $pull: { completedChapters: chapterId } },
            { new: true }
        ).lean().exec();
    
        return updatedUserCourseAnalysis;
        } catch (error) {
        throw error;
        }
    };

const UserCourseAnalysisControllers = { addChapter, removeChapter };

export default UserCourseAnalysisControllers