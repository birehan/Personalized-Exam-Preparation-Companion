import { Request, Response, NextFunction } from 'express';
import ContestPrize from '../models/contestPrize';
import { contestPrizeValidation } from '../validations/joiModelValidator';
import { BaseResponse } from '../types/baseResponse';

const createContestPrize = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { prizeIds, contestId } = req.body;
    const userInput = { prizeIds, contestId };

    const { error, value } = contestPrizeValidation(userInput, 'post');
    if (error) throw error;

    const foundContestPrize = await ContestPrize.findOne({contestId,}).lean().exec();

    if (foundContestPrize){ throw Error("Prize already created for this contest! Try updating instead!")}

    const contestPrize = new ContestPrize({ ...value });
    const savedContestPrize = await contestPrize.save();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'ContestPrize created successfully!';
    baseResponse.data = {
      newContestPrize: savedContestPrize,
    };

    return res.status(201).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getContestPrizes = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const contestPrizes = await ContestPrize.find().lean().exec();
    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'ContestPrizes retrieved successfully!';
    baseResponse.data = {
      contestPrizes,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getContestPrize = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const id = req.params.id;
    const contestPrize = await ContestPrize.findOne({ _id: id }).lean().exec();

    if (!contestPrize) throw Error('ContestPrize not found with that Id.');

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'ContestPrize retrieved successfully!';
    baseResponse.data = {
      contestPrize,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const updateContestPrize = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const contestPrizeToBeUpdated = await ContestPrize.findById(id).lean().exec();

    if (!contestPrizeToBeUpdated) throw Error('ContestPrize not found with that Id.');

    const { prizeIds, contestId } = req.body;
    let updateObject = { prizeIds, contestId };

    for (const key in updateObject) {
      if (!updateObject[key]) delete updateObject[key];
    }

    const { error, value } = contestPrizeValidation(updateObject, 'put');
    if (error) throw error;

    const updatedContestPrize = await ContestPrize.findByIdAndUpdate(id, value, { new: true })
      .lean()
      .exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'ContestPrize updated successfully!';
    baseResponse.data = {
      updatedContestPrize,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const deleteContestPrize = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const contestPrizeToBeDeleted = await ContestPrize.findById(id).lean().exec();

    if (!contestPrizeToBeDeleted) throw Error('ContestPrize not found with that Id.');

    const deletedContestPrize = await ContestPrize.findByIdAndDelete(id).lean().exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'ContestPrize deleted successfully!';
    baseResponse.data = {
      deletedContestPrize,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const contestPrizeController = {
  createContestPrize,
  getContestPrizes,
  getContestPrize,
  updateContestPrize,
  deleteContestPrize,
};

export default contestPrizeController;
