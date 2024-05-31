import { Request, Response, NextFunction } from 'express';
import VideoContent from '../models/videoContent';
import { videoContentValidator } from '../validations/joiModelValidator';
import { BaseResponse } from '../types/baseResponse';
import Chapter from '../models/chapter';
import SubChapter from '../models/subChapter';
import Course from '../models/course';
import UserVideoAnalysis from '../models/userVideoAnalysis';
import { isValidObjectId } from 'mongoose';
import { get } from 'http';

const createVideoContent = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const {
            courseId, chapterId, subChapterId,
            title, order, duration, link, thumbnail,videoChannelId
        } = req.body;

        const userInput = { courseId, chapterId, subChapterId, title, order, duration, link, thumbnail,videoChannelId };

        const { error, value } = videoContentValidator(userInput, "post");

        if (error) throw error;

        const foundCourse = await Course.findById(chapterId);
        if (!foundCourse) throw Error("Course Id does not exist");
        
        const foundChapter = await Chapter.findById(chapterId);
        if (!foundChapter) throw Error("Chapter Id does not exist");

        const foundSubChapter = await SubChapter.findById(subChapterId);
        if (!foundSubChapter) throw Error("SubChapter Id does not exist");

        const videoContent = new VideoContent({...value});

        const savedVideoContent = await videoContent.save();

        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'VideoContent created successfully!';
        baseResponse.data = {
            newVideoContent: savedVideoContent
        };

        return res.status(201).json({...baseResponse});
    } catch (error) {
        next(error);
    }
}

const getVideoContents = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const videoContents = await VideoContent.find().lean().populate('videoChannelId').exec();
        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'VideoContents retrieved successfully!';
        baseResponse.data = {
            videoContents,
        };

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error);
    }
}
const getByChannelId = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { channelId } = req.params;
        if (!isValidObjectId(channelId)) throw Error("Invalid Channel Id");

        const videoContents = await VideoContent.find({videoChannelId: channelId}).populate('videoChannelId').lean().exec();
        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'VideoContents retrieved successfully!';
        baseResponse.data = {
            videoContents,
        };
        res.status(200).json({...baseResponse});
    } catch (error) {
        next(error);
    }   
}

const getVideoContent = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const id = req.params.id;
        const videoContent = await await VideoContent.findOne({_id:id}).populate('videoChannelId').lean().exec();

        if (!videoContent) throw Error("VideoContent not found with that Id.");

        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'VideoContent retrieved successfully!';
        baseResponse.data = {
            videoContent,
        };

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error);
    }
}

const updateVideoContent = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const videoContentToBeUpdated = await VideoContent.findById(id).lean().exec();

        if (!videoContentToBeUpdated) throw Error("VideoContent not found with that Id.");

        const {
            courseId, chapterId, subChapterId,
            title, order, duration, link,videoChannelId
        } = req.body;

        let updateObject = { courseId, chapterId, subChapterId, title, order, duration, link ,videoChannelId};

        for (const key in updateObject) {
            if (!updateObject[key]) delete updateObject[key];
        }
        
        if (chapterId) {
            const foundChapter = await Chapter.findById(chapterId);
            if (!foundChapter) throw Error("Chapter Id does not exist");
        }

        if (subChapterId) {
            const foundSubChapter = await SubChapter.findById(subChapterId);
            if (!foundSubChapter) throw Error("SubChapter Id does not exist");
        }

        const { error, value } = videoContentValidator(updateObject, "put");

        if (error) throw error;

        const updatedVideoContent = await VideoContent.findByIdAndUpdate(id, value, {new: true}).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'VideoContent updated successfully!';
        baseResponse.data = {
            updatedVideoContent,
        };

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error);
    }
}

const deleteVideoContent = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const videoContentToBeDeleted = await VideoContent.findById(id).lean().exec();

        if (!videoContentToBeDeleted) throw Error("VideoContent not found with that Id.");

        const deletedVideoContent = await VideoContent.findByIdAndDelete(id).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'VideoContent deleted successfully!';
        baseResponse.data = {
            deletedVideoContent,
        };

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error);
    }
}

const getVideoContentsByCourse = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const userId= req.body.user._id;

        const foundCourse = await Course.findOne({_id: id}).lean().exec()

        if (!foundCourse){
            throw Error("There is no course by that ID!")
        }

        const chapters = await Chapter.find({ courseId: id }).sort({order: 1}).select("-createdAt -updatedAt").lean().exec();

        const groupedVideoContents = [];

        for (const chapter of chapters) {
            const videoContents = await VideoContent.find({ chapterId: chapter._id.toString() }).select("-createdAt -updatedAt").sort({order: 1}).lean().exec();
            for (const videoContent of videoContents) {
                const userVideoAnalysis = await UserVideoAnalysis.findOne({ userId, videoId: videoContent._id }).lean().exec();
                const completed = userVideoAnalysis ? userVideoAnalysis.completed : false;

                videoContent['completed'] = completed;
            }
            const chapterData = {
                chapter,
                videoContents
            };

            groupedVideoContents.push(chapterData);
        }

        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'Video contents retrieved successfully!';
        baseResponse.data = groupedVideoContents;

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error);
    }
}

const updateUserVideoAnalysis = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const userId= req.body.user._id
        const videoId= req.params.id
        const { completed } = req.body;

        let userVideoAnalysis = await UserVideoAnalysis.findOne({ userId, videoId });

        if (!userVideoAnalysis) {
            userVideoAnalysis = new UserVideoAnalysis({ userId, videoId, completed });
            await userVideoAnalysis.save();
        } else {
            userVideoAnalysis.completed = completed;
            await userVideoAnalysis.save();
        }
        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'Video contents status updated successfully!';
        baseResponse.data = userVideoAnalysis;
        return res.status(200).json({ ...baseResponse });
    } catch (error) {
        next(error);
    }
}

const videoContentControllers = {createVideoContent, updateUserVideoAnalysis, updateVideoContent, getVideoContents, getVideoContent, deleteVideoContent, getVideoContentsByCourse,getByChannelId}

export default videoContentControllers;
