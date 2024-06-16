import { Request, Response, NextFunction } from "express";
import UserContentBookmark from "../models/userContentBookmark";
import { userContentBookmarkValidator } from "../validations/joiModelValidator";
import { BaseResponse } from '../types/baseResponse';
import SubChapterContent from "../models/subChapterContent";

const createUserContentBookmark = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const userId = req.body.user._id.toString();

    const { contentId } = req.body;

    const userInput = { userId, contentId };

    const { error, value } = userContentBookmarkValidator(userInput, 'post');

    const foundContent = await SubChapterContent.findById(contentId).lean().exec();

    if (!foundContent) {
      throw new Error('No content with that ID!');
    }

    if (error) throw error;

    const foundBookmark = await UserContentBookmark.findOne({ userId, contentId,});

    if (foundBookmark) {
      throw new Error('User already bookmarked this content!');
    }

    const userBookmark = new UserContentBookmark({...value});

    const saveduserBookmark = await userBookmark.save();

    let baseResponse = new BaseResponse();

    baseResponse. success = true,
    baseResponse. message = 'User successfully bookmarked the content!';
    baseResponse.data =  { newUserBookmark: saveduserBookmark }

    return res.status(201).json(baseResponse);
  } catch (error) {
    next(error);
  }
};

const deleteUserContentBookmark = async (req: Request, res: Response, next: NextFunction) => {
    try {

        const { id } = req.params;
        const userId = req.body.user._id.toString();

        const userBookmarkToBeDeleted = await UserContentBookmark.findOne({contentId:id, userId,}).lean().exec();

        if (!userBookmarkToBeDeleted) throw Error("User bookmark not found with that Id.");

        const deletedUserBookmark = await UserContentBookmark.findOneAndDelete({contentId:id, userId,}).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'User bookmark deleted successfully!'
        baseResponse.data = {
            deletedUserBookmark,
        }

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error)
    }
}

const userContentBookmarkController = { createUserContentBookmark, deleteUserContentBookmark};
export default userContentBookmarkController;