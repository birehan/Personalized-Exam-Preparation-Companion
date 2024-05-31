import { Request, Response, NextFunction } from 'express';
import Prize from '../models/prize';
import { prizeValidation } from '../validations/joiModelValidator';
import { BaseResponse } from '../types/baseResponse';

const createPrize = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { standing, description, type, amount } = req.body;
    const userInput = { standing, description, type, amount };

    const { error, value } = prizeValidation(userInput, 'post');
    if (error) throw error;

    const prize = new Prize({ ...value });
    const savedPrize = await prize.save();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Prize created successfully!';
    baseResponse.data = {
      newPrize: savedPrize,
    };

    return res.status(201).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getPrizes = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const prizes = await Prize.find().lean().exec();
    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Prizes retrieved successfully!';
    baseResponse.data = {
      prizes,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getPrize = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const id = req.params.id;
    const prize = await Prize.findOne({ _id: id }).lean().exec();

    if (!prize) throw Error('Prize not found with that Id.');

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Prize retrieved successfully!';
    baseResponse.data = {
      prize,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const updatePrize = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const prizeToBeUpdated = await Prize.findById(id).lean().exec();

    if (!prizeToBeUpdated) throw Error('Prize not found with that Id.');

    const { standing, description, type, amount } = req.body;
    let updateObject = { standing, description, type, amount };

    for (const key in updateObject) {
      if (!updateObject[key]) delete updateObject[key];
    }

    const { error, value } = prizeValidation(updateObject, 'put');
    if (error) throw error;

    const updatedPrize = await Prize.findByIdAndUpdate(id, value, { new: true }).lean().exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Prize updated successfully!';
    baseResponse.data = {
      updatedPrize,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const deletePrize = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const prizeToBeDeleted = await Prize.findById(id).lean().exec();

    if (!prizeToBeDeleted) throw Error('Prize not found with that Id.');

    const deletedPrize = await Prize.findByIdAndDelete(id).lean().exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Prize deleted successfully!';
    baseResponse.data = {
      deletedPrize,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const prizeController = {
  createPrize,
  getPrizes,
  getPrize,
  updatePrize,
  deletePrize,
};

export default prizeController;
