import { Request, Response, NextFunction } from 'express';
import { chapterValidator } from '../validations/joiModelValidator';
import { BaseResponse } from '../types/baseResponse';
import Chapter from '../models/chapter';
import Course from '../models/course';
import Question from '../models/question';

const createChapter = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const {
            name,
            description,
            summary,
            courseId,
            noOfSubChapters
        } = req.body;

        const userInput = {
            name, description, summary, courseId,noOfSubChapters
        }

        const { error, value } = chapterValidator(userInput, "post");

        const foundCourse = await Course.findOne({ _id: courseId }).lean().exec();

        if (!foundCourse) throw Error("Course not find  with ID.");
        await Course.findByIdAndUpdate(courseId, {noOfChapters:Number(foundCourse.noOfChapters) + 1})
        if (error) throw error

        const chapter = new Chapter({ ...value });

        const savedChapter = await chapter.save();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Chapter created successfully!'
        baseResponse.data = {
            newChapter: savedChapter
        }

        return res.status(201).json({ ...baseResponse })
    } catch (error) {
        next(error)
    };
}

const getChapters = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const chapters = await Chapter.find().lean().exec();
        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Chapters retrieved successfully!'
        baseResponse.data = {
            chapters,
        }

        return res.status(200).json({ ...baseResponse });
    } catch (error) {
        next(error)
    }
}

const getChaptersOfCourse = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const courseId = req.params.courseId;

        const foundCourse = await Course.findOne({_id: courseId}).lean().exec();
        if (!foundCourse) throw Error("Course not found with that Id.")

        const chapters = await Chapter.find({courseId,}).lean().exec();
        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Course Chapters retrieved successfully!'
        baseResponse.data = {
            chapters,
        }

        return res.status(200).json({ ...baseResponse });
    } catch (error) {
        next(error)
    }
}

const getChapter = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const id = req.params.id;
        const chapter = await Chapter.findOne({ _id: id }).lean().exec();

        if (!chapter) throw Error("Chapter not found with that Id.")

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Chapter retrieved successfully!'
        baseResponse.data = {
            chapter,
        }

        return res.status(200).json({ ...baseResponse });

    } catch (error) {
        next(error)
    }
}

const updateChapter = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const chapterToBeUpdated = await Chapter.findById(id).lean().exec();

        if (!chapterToBeUpdated) throw Error("Chapter not found with that Id.")

        const {
            name,
            description,
            summary,
            courseId,
            noOfSubChapters,
        } = req.body;

        let updateObject = {
            name,
            description,
            summary,
            courseId,
            noOfSubChapters
        }

        for (const key in updateObject) {
            if (!updateObject[key]) delete updateObject[key]
        }

        const { error, value } = chapterValidator(updateObject, "put");
        let foundCourse
        if (courseId){
            foundCourse = await Course.findOne({ _id: courseId }).lean().exec();
            if (!foundCourse) throw Error("Course not found with ID.");
        }
        

        if (error) throw error;

        const updatedChapter = await Chapter.findByIdAndUpdate(id, value, { new: true }).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Chapter updated successfully!'
        baseResponse.data = {
            updatedChapter,
        }
        return res.status(200).json({ ...baseResponse })

    } catch (error) {
        next(error)
    }
}

const deleteChapter = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const chapterToBeDeleted = await Chapter.findById(id).lean().exec();

        if (!chapterToBeDeleted) throw Error("Chapter not found with that Id.");

        const deletedChapter = await Chapter.findByIdAndDelete(id).lean().exec();

        const course = await Course.findOne({_id: chapterToBeDeleted.courseId}).lean().exec()

        await Course.findByIdAndUpdate(course._id, {noOfChapters:Number(course.noOfChapters) -1})
        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Chapter deleted successfully!'
        baseResponse.data = {
            deletedChapter,
        }

        return res.status(200).json({ ...baseResponse });
    } catch (error) {
        next(error)
    }
}


const chapterControllers = { createChapter, getChapter, getChapters, getChaptersOfCourse, updateChapter, deleteChapter }

export default chapterControllers