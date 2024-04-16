import { Request, Response, NextFunction } from 'express';
import Question from '../models/question';
import Chapter from '../models/chapter';
import Course from '../models/course';
import SubChapter from '../models/subChapter';
import { questionValidator } from '../validations/joiModelValidator';
import { BaseResponse } from '../types/baseResponse';

const createQuestion = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const {
            description, choiceA,
            choiceB,choiceC,choiceD,
            answer,explanation,relatedTopic, 
            chapterId, courseId, subChapterId
        } = req.body;

        const userInput = { description, choiceA, choiceB,choiceC,choiceD,
            answer,explanation,relatedTopic, chapterId, courseId, subChapterId }

        const { error, value } = questionValidator(userInput,"post");

        if (error) throw error
        
        const foundChapter = await Chapter.findById(chapterId)
        const foundCourse = await Course.findById(courseId)
        const foundSubChapter = await SubChapter.findById(subChapterId)

        if (!foundChapter) throw Error("Chapter Doesn't Exixt")
        if (!foundCourse) throw Error("Course Doesn't Exixt")
        if (!foundSubChapter) throw Error("Sub Chapter Doesn't Exixt")
        
        const question = new Question({...value});

        const savedQuestion = await question.save();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Question created successfully!'
        baseResponse.data = {
        newQuestion: savedQuestion
        }

        return res.status(201).json({...baseResponse})
    } catch (error) {
        next(error)
    };
}

const getQuestions = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const questions = await Question.find().lean().exec();
        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Questions retrieved successfully!'
        baseResponse.data = {
        questions,
        }

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error)
    }
}

const getQuestion = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const id = req.params.id;
        const question = await Question.findOne({_id:id}).lean().exec();

        if (!question) throw Error("Question not found with that Id.")

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Question retrieved successfully!'
        baseResponse.data = {
        question,
        }

        return res.status(200).json({...baseResponse});

    } catch (error) {
        next(error)
    }
}

const updateQuestion = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const questionToBeUpdated = await Question.findById(id).lean().exec();

        if (!questionToBeUpdated) throw Error("Question not found with that Id.")

        const {
            description, choiceA,
            choiceB,choiceC,choiceD,
            answer,explanation,isForQuiz,
            chapterId, courseId, subChapterId
        } = req.body;

        let updateObject = { description, choiceA, choiceB,choiceC,choiceD,
            answer,explanation,isForQuiz, chapterId, courseId, subChapterId }

        for (const key in updateObject){
            if (!updateObject[key]) delete updateObject[key]
        }

        const { error, value } = questionValidator(updateObject,"put");

        if (error) throw error;

        let foundChapter
        let foundCourse
        let foundSubChapter
        if (chapterId){
            foundChapter = await Chapter.findById(chapterId)
            if (!foundChapter) throw Error("Chapter Doesn't Exixt")
        }
        if(courseId){
            foundCourse = await Course.findById(courseId)
            if (!foundCourse) throw Error("Course Doesn't Exixt")
        }
        if(subChapterId){
            foundSubChapter = await SubChapter.findById(subChapterId)
            if (!foundSubChapter) throw Error("Sub Chapter Doesn't Exixt")
        }
        

        const updatedQuestion = await Question.findByIdAndUpdate(id, value, {new: true}).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Question updated successfully!'
        baseResponse.data = {
            updatedQuestion,
        }
        return res.status(200).json({...baseResponse})

    } catch (error) {
        next(error)
    }
}

const deleteQuestion = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const questionToBeDeleted = await Question.findById(id).lean().exec();

        if (!questionToBeDeleted) throw Error("Question not found with that Id.");

        const deletedQuestion = await Question.findByIdAndDelete(id).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Question deleted successfully!'
        baseResponse.data = {
            deletedQuestion,
        }

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error)
    }
}

const questionControllers = {createQuestion, getQuestions, getQuestion, updateQuestion, deleteQuestion}

export default questionControllers