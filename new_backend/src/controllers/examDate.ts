import { Request, Response, NextFunction } from 'express';
import ExamDate from '../models/examDate';
import { examDateValidator } from '../validations/joiModelValidator';
import { BaseResponse } from '../types/baseResponse';

const createExamDate = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { date} = req.body;

        const userInput = { date };

        const { error, value } = examDateValidator(userInput,"post");

        if (error) throw error

        const examDate = new ExamDate({...value});

        const savedExamDate = await examDate.save();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Exam Date created successfully!'
        baseResponse.data = {
        newExamDate: savedExamDate
        }

        return res.status(201).json({...baseResponse})
    } catch (error) {
        next(error)
    };
}

const getExamDates = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const examDates = await ExamDate.find().sort({ createdAt: -1 }).lean().exec();
        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Exam Dates retrieved successfully!'
        baseResponse.data = {
            examDates,
        }

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error)
    }
}

const getExamDate = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const id = req.params.id;
        const examDate = await ExamDate.findOne({_id:id}).lean().exec();

        if (!examDate) throw Error("Exam Date not found with that Id.")

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Exam Date retrieved successfully!'
        baseResponse.data = {
            examDate,
        }

        return res.status(200).json({...baseResponse});

    } catch (error) {
        next(error)
    }
}

const updateExamDate = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const examDateToBeUpdated = await ExamDate.findById(id).lean().exec();

        if (!examDateToBeUpdated) throw Error("Exam Date not found with that Id.")

        const { date } = req.body;

        let updateObject = { date }

        for (const key in updateObject){
            if (!updateObject[key]) delete updateObject[key]
        }

        const { error, value } = examDateValidator(updateObject,"put");

        if (error) throw error;

        const updatedExamDate = await ExamDate.findByIdAndUpdate(id, value, {new: true}).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Exam Date updated successfully!'
        baseResponse.data = {
            updatedExamDate,
        }
        return res.status(200).json({...baseResponse})

    } catch (error) {
        next(error)
    }
}

const deleteExamDate = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const generalDepartmentToBeDeleted = await ExamDate.findById(id).lean().exec();

        if (!generalDepartmentToBeDeleted) throw Error("Exam Date not found with that Id.");

        const deletedGeneralDepartment = await ExamDate.findByIdAndDelete(id).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Exam Date deleted successfully!'
        baseResponse.data = {
            deletedGeneralDepartment,
        }

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error)
    }
}

const examDateControllers = {createExamDate, getExamDates, getExamDate, updateExamDate, deleteExamDate}

export default examDateControllers