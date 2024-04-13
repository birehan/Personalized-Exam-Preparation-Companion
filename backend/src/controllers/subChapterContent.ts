import { Request, Response, NextFunction } from 'express';
import SubChapterContent from '../models/subChapterContent';
import { subChapterContentValidator } from '../validations/joiModelValidator';
import { BaseResponse } from '../types/baseResponse';
import SubChapter from '../models/subChapter';

const createSubChapterContent = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const {
            title, content,
            subChapterId,
        } = req.body;

        const userInput = { title, content, subChapterId}

        const { error, value } = subChapterContentValidator(userInput,"post");

        if (error) throw error

        const foundSubChapter = await SubChapter.findById(subChapterId)
        if(!foundSubChapter) throw Error("Sub chapter doesn't exist")

        const subChapterContent = new SubChapterContent({...value});

        const savedSubChapterContent = await subChapterContent.save();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'SubChapterContent created successfully!'
        baseResponse.data = {
        newSubChapterContent: savedSubChapterContent
        }

        return res.status(201).json({...baseResponse})
    } catch (error) {
        next(error)
    };
}

const getSubChapterContents = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const subChapterContents = await SubChapterContent.find().lean().exec();
        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'SubChapterContents retrieved successfully!'
        baseResponse.data = {
        subChapterContents,
        }

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error)
    }
}

const getSubChapterContent = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const id = req.params.id;
        const subChapterContent = await SubChapterContent.findOne({_id:id}).lean().exec();

        if (!subChapterContent) throw Error("SubChapterContent not found with that Id.")

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'SubChapterContent retrieved successfully!'
        baseResponse.data = {
        subChapterContent,
        }

        return res.status(200).json({...baseResponse});

    } catch (error) {
        next(error)
    }
}

const updateSubChapterContent = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const subChapterContentToBeUpdated = await SubChapterContent.findById(id).lean().exec();

        if (!subChapterContentToBeUpdated) throw Error("SubChapterContent not found with that Id.")

        const {
            title, content,
            subChapterId,
        } = req.body;

        let updateObject = { title, content, subChapterId}

        for (const key in updateObject){
            if (!updateObject[key]) delete updateObject[key]
        }

        let foundSubChapter
        if(subChapterId){
            foundSubChapter = await SubChapter.findById(subChapterId)
            if(!foundSubChapter) throw Error("Sub chapter doesn't exist")
        }
        
        const { error, value } = subChapterContentValidator(updateObject,"put");

        if (error) throw error;

        const updatedSubChapterContent = await SubChapterContent.findByIdAndUpdate(id, value, {new: true}).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'SubChapterContent updated successfully!'
        baseResponse.data = {
            updatedSubChapterContent,
        }
        return res.status(200).json({...baseResponse})

    } catch (error) {
        next(error)
    }
}

const deleteSubChapterContent = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const subChapterContentToBeDeleted = await SubChapterContent.findById(id).lean().exec();

        if (!subChapterContentToBeDeleted) throw Error("SubChapterContent not found with that Id.");

        const deletedSubChapterContent = await SubChapterContent.findByIdAndDelete(id).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'SubChapterContent deleted successfully!'
        baseResponse.data = {
            deletedSubChapterContent,
        }

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error)
    }
}

const SubChapterContentControllers = {createSubChapterContent, getSubChapterContents, getSubChapterContent, updateSubChapterContent, deleteSubChapterContent}

export default SubChapterContentControllers