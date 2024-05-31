import { Request, Response, NextFunction } from 'express';
import ContentReview, { IContentReviewDocument } from '../models/contentReview';
import { contentReviewValidation } from '../../validations/joiModelValidator';
import { BaseResponse } from '../../types/baseResponse';
import SubChapterContent from '../../models/subChapterContent';
import Reviewer from '../models/reviewer';
import SubChapterReview from '../models/subChapterReview';

const createContentReview = async (req: Request, res: Response, next: NextFunction) => {
  try {
    // requestedBy should be taken from the auth middleware: it should be authorized that the user should be Admin

    const { subChapterContentId, reviewerId, comment, requestedBy } = req.body;

    const userInput = { subChapterContentId, reviewerId, comment, requestedBy };

    const { error, value } = contentReviewValidation(userInput, 'post');

    if (error) throw error;

    const foundSubChapterContent = await SubChapterContent.findOne({_id: subChapterContentId}).lean().exec();

    if (!foundSubChapterContent){ throw Error("subchapter content not found!")}

    const foundReviewer = await Reviewer.findOne({_id: reviewerId}).lean().exec();

    if(!foundReviewer){throw Error("Reveiwer not found with that ID")}

    const contentReview = new ContentReview({ ...value });

    const savedContentReview = await contentReview.save();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Content review created successfully!';
    baseResponse.data = {
      newContentReview: savedContentReview,
    };

    return res.status(201).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getContentReviews = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const contentReviews = await ContentReview.find().lean().exec();
    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Content reviews retrieved successfully!';
    baseResponse.data = {
      contentReviews,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getContentReview = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const id = req.params.id;
    const contentReview = await ContentReview.findOne({ _id: id }).lean().exec();

    if (!contentReview) throw Error('Content review not found with that Id.');

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Content review retrieved successfully!';
    baseResponse.data = {
      contentReview,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const updateContentReview = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const contentReviewToBeUpdated = await ContentReview.findById(id).lean().exec();

    if (!contentReviewToBeUpdated) throw Error('Content review not found with that Id.');

    const { subChapterContentId, status, reviewerId, comment, requestedBy } = req.body;

    let updateObject = { subChapterContentId, status, reviewerId, comment, requestedBy };

    for (const key in updateObject) {
      if (!updateObject[key]) delete updateObject[key];
    }

    // [TO:DO ] additional validation for subChapterContentId, reviewerId, and requestedBy

    const { error, value } = contentReviewValidation(updateObject, 'put');

    if (error) throw error;

    const updatedContentReview = await ContentReview.findByIdAndUpdate(id, value, { new: true }).lean().exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Content review updated successfully!';
    baseResponse.data = {
      updatedContentReview,
    };
    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const deleteContentReview = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const contentReviewToBeDeleted = await ContentReview.findById(id).lean().exec();

    if (!contentReviewToBeDeleted) throw Error('Content review not found with that Id.');

    const deletedContentReview = await ContentReview.findByIdAndDelete(id).lean().exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Content review deleted successfully!';
    baseResponse.data = {
      deletedContentReview,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const reviewerContentApproval = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const reviewerId = req.body.userDetails._id.toString()
    const contentReviewToBeUpdated = await ContentReview.findOne({_id: id, reviewerId,}).lean().exec();

    if (!contentReviewToBeUpdated) throw Error('Content review not found with that Id.');

    const foundSubChapterReview = await SubChapterReview.findOne({_id: contentReviewToBeUpdated.subChapterReviewId, reviewerId,}).lean().exec()

    if (!foundSubChapterReview || foundSubChapterReview.status !== "pending"){
      throw Error("SubChapter is not assigned to the reviewer or subChapter review is already submitted!")
    }

    const { status, comment } = req.body;

    let updateObject = { status, comment };

    for (const key in updateObject) {
      if (!updateObject[key]) delete updateObject[key];
    }

    const { error, value } = contentReviewValidation(updateObject, 'put');

    if (error) throw error;

    const updatedContentReview = await ContentReview.findByIdAndUpdate(id, value, { new: true }).lean().exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Content approval was successfully!';
    baseResponse.data = {
      updatedContentReview,
    };
    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const contentReviewControllers = {
  createContentReview,
  getContentReviews,
  getContentReview,
  updateContentReview,
  deleteContentReview,
  reviewerContentApproval
};

export default contentReviewControllers;