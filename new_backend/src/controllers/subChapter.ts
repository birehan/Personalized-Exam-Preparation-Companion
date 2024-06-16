import { Request, Response, NextFunction } from 'express';
import { subChapterValidator } from '../validations/joiModelValidator';
import { BaseResponse } from '../types/baseResponse';
import SubChapter from '../models/subChapter';
import Chapter from '../models/chapter';
import SubChapterContent from '../models/subChapterContent';
import { Mongoose, Schema } from 'mongoose';
import { ObjectId } from 'mongodb'
import Question from '../models/question';
import QuestionUserAnswer from '../models/questionUserAnswer';
import { QuestionAnswers } from '../models/questionUserAnswer';
import UserChapterAnalysis from '../models/userChapterAnalysis';
import UserQuestionVote from '../models/userQuestionVote';
import UserContentBookmark from '../models/userContentBookmark';


const createSubChapter = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const {
            name,
            contents,
            chapterId
        } = req.body;

        const userInput = {
            name, contents, chapterId
        }

        const { error, value } = subChapterValidator(userInput, "post");

        const foundChapter = await Chapter.findOne({ _id: chapterId }).lean().exec();

        if (!foundChapter) throw Error("Chapter not found with ID.");
        const newNoOfSubChapters:number = Number( foundChapter.noOfSubChapters)+ 1
        await Chapter.findByIdAndUpdate(chapterId, {noOfSubChapters: newNoOfSubChapters}).lean().exec();

        if (error) throw error

        const subChapter = new SubChapter({ ...value });

        const savedSubChapter = await subChapter.save();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Sub-chapter created successfully!'
        baseResponse.data = {
            newSubChapter: savedSubChapter
        }

        return res.status(201).json({ ...baseResponse })
    } catch (error) {
        next(error)
    };
}

const getSubChapters = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const userId = req.body.user._id.toString();
        const { chapterId } = req.params;
        const foundChapter = await Chapter.findOne({ _id: chapterId }).lean().exec();

        if (!foundChapter) throw Error("Chapter not found with ID.");

        const subChapters = await SubChapter.find({chapterId,}).sort({order: 1}).lean().exec();
        const completedSubChapters = await UserChapterAnalysis.findOne({userId, chapterId, }).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Sub-chapters retrieved successfully!'
        baseResponse.data = {
            subChapters,
            completedSubChapters: completedSubChapters?.completedSubChapters || [],
        }

        return res.status(200).json({ ...baseResponse });
    } catch (error) {
        next(error)
    }
}

const getSubChapter = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const userId = req.body.user._id;
        const id = req.params.id;

       let subChapter=  await SubChapter.aggregate([
        {
          $match: {
            _id: new ObjectId(id),
            adminApproval: true
          },
        },
        {
            $lookup: {
                from: 'subchaptercontents',
                let: { subChapterId: '$_id' },
                pipeline: [
                    {
                        $match: {
                            $expr: {
                                $and: [
                                    { $eq: ['$subChapterId', '$$subChapterId'] },
                                    { $eq: ['$adminApproval', true] }
                                ]
                            }
                        }
                    }
                ],
                as: 'contents',
            },
        },
        {
            $unwind: {
              path: '$contents',
              preserveNullAndEmptyArrays: true,
            },
          },
        {
          $sort: {
            'contents.order': 1,
          },
        },
        {
          $group: {
            _id: '$_id',
            name: { $first: '$name' },
            chapterId: { $first: '$chapterId' },
            createdAt: { $first: '$createdAt' },
            updatedAt: { $first: '$updatedAt' },
            contents: { $push: '$contents' },
          },
        },
      ], { maxTimeMS: 60000, allowDiskUse: true });      
      if (!subChapter || subChapter.length === 0) throw Error("No topic found with that ID!")

      const contents = subChapter[0].contents;

        const isBookmarkedPromises = contents.map(async (content) => {
            const contentId = content._id;
            const isBookmarked = await UserContentBookmark.exists({
                userId,
                contentId
            });
            return !!isBookmarked;
        });

        const isBookmarkedResults = await Promise.all(isBookmarkedPromises);

        const contentsWithIsBookmarked = contents.map((content, index) => {
            return {
                ...content,
                isbookmarked: isBookmarkedResults[index]
            };
        });

        subChapter[0].contents = contentsWithIsBookmarked

        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'Sub-chapter retrieved successfully!';
        baseResponse.data = {
            subChapter: subChapter[0]
        };

        return res.status(200).json({ ...baseResponse });

    } catch (error) {
        next(error)
    }
}

const updateSubChapter = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const subChapterToBeUpdated = await SubChapter.findById(id).lean().exec();

        if (!subChapterToBeUpdated) throw Error("Sub-chapter not found with that Id.")

        const {
            name,
            contents,
            chapterId
        } = req.body;

        let updateObject = {
            name,
            contents,
            chapterId
        }

        for (const key in updateObject) {
            if (!updateObject[key]) delete updateObject[key]
        }

        const { error, value } = subChapterValidator(updateObject, "put");

        const foundChapter = await Chapter.findOne({ _id: chapterId }).lean().exec();

        if (!foundChapter) throw Error("Chapter not found with ID.");

        if (error) throw error;

        const updatedSubChapter = await SubChapter.findByIdAndUpdate(id, value, { new: true }).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Sub-chapter updated successfully!'
        baseResponse.data = {
            updatedSubChapter,
        }
        return res.status(200).json({ ...baseResponse })

    } catch (error) {
        next(error)
    }
}

const deleteSubChapter = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const subChapterToBeDeleted = await SubChapter.findById(id).lean().exec();

        if (!subChapterToBeDeleted) throw Error("Sub-chapter not found with that Id.");

        const deletedSubChapter = await SubChapter.findByIdAndDelete(id).lean().exec();

        const {chapterId} = deletedSubChapter
        const chapter = await Chapter.findById(chapterId).lean().exec();

        await Chapter.findByIdAndUpdate(chapterId, {noOfSubChapters: Number(chapter.noOfSubChapters) - 1},{new:true}).lean().exec();
    

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Chapter deleted successfully!'
        baseResponse.data = {
            deletedSubChapter,
        }

        return res.status(200).json({ ...baseResponse });
    } catch (error) {
        next(error)
    }
}

const getEndOfSubChapterQuestion = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const userId = req.body.user._id.toString();
        const id = req.params.id;

        const endOfSubChapterQuestions = await Question.find({subChapterId:id, isForQuiz:false, isForMock: false}).lean().exec();

        const questionsUserAnsPromises = endOfSubChapterQuestions.map(async (question: any) => {
        const questionId = question._id;
        const userQuestionAnswer = await QuestionUserAnswer.findOne({ userId, questionId }).lean().exec();
        return userQuestionAnswer || { userId, questionId, userAnswer: QuestionAnswers.E };
        });
    
        const questionsUserAnsResults = await Promise.all(questionsUserAnsPromises);

        const questionsWithUserAns = endOfSubChapterQuestions.map((question: any, index: number) => {
            const userAnswer = questionsUserAnsResults[index];
            return {
            question: {...question, isLiked: false},
            userAnswer: userAnswer
            };
        });

        for (const eachQuestionWithUserAns of questionsWithUserAns) {
            const questionId = eachQuestionWithUserAns.question._id;
            const itExists = await UserQuestionVote.findOne({ userId, questionId }).exec();
            if(itExists) {eachQuestionWithUserAns.question.isLiked = true;}
        }

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Questions retrieved successfully!'
        baseResponse.data = {
          questions:questionsWithUserAns,
        }

        return res.status(200).json({...baseResponse});

    } catch (error) {
        next(error)
    }
}


const subChapterControllers = { createSubChapter, getSubChapter, getSubChapters, updateSubChapter, deleteSubChapter,getEndOfSubChapterQuestion }

export default subChapterControllers