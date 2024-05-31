import { Request, Response, NextFunction } from "express";
import ContentFlag from "../models/contentFlag";
import { contentFlagValidator } from "../validations/joiModelValidator";
import SubChapterContent from "../models/subChapterContent";
import { BaseResponse } from '../types/baseResponse';

const createUserContentFlag = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const userId = req.body.user._id.toString();

    const { subChapterContentId, comment } = req.body;

    const userInput = { userId, subChapterContentId, comment };

    const { error, value } = contentFlagValidator(userInput, 'post');
    if (error) throw error;

    const foundSubChapter = await SubChapterContent.findOne({ _id: subChapterContentId });

    if (!foundSubChapter) {
      throw new Error('No SubChapterContent found with that ID');
    }

    const filter = { userId, subChapterContentId };
    const update = { $set: { comment }, $setOnInsert: { createdAt: new Date() } };
    const options = { upsert: true, new: true, setDefaultsOnInsert: true };

    const savedContentFlag = await ContentFlag.findOneAndUpdate(filter, update, options);

    let baseResponse = new BaseResponse();

    baseResponse. success = true,
    baseResponse. message = 'Content Flag created/updated successfully!';
    baseResponse.data =  { newContentFlag: savedContentFlag }

    return res.status(201).json(baseResponse);
  } catch (error) {
    next(error);
  }
};

const getContentFlags = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const contentFlags = await ContentFlag.find().lean().exec();
        let baseResponse = new BaseResponse();

        baseResponse.success = true
        baseResponse.message = 'Question flags retrieved successfully!'
        baseResponse.data = {
            contentFlags,
        }

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error)
    }
}

const contentFlagController = { createUserContentFlag, getContentFlags};
export default contentFlagController;