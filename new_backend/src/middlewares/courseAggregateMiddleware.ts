import { Request, Response, NextFunction} from 'express'
import Course from '../models/course';
import { ObjectId } from 'mongodb';

const aggregateMiddleware = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const name = req.query.name?.toString();
    const departmentId = new ObjectId(req.body.user.department.toString());

    let pipeline = [];

    if (name) {
      const regex = new RegExp(`.*${name}.*`, 'i');
      pipeline = [
        {
          $match: {
            name: {
              $regex: regex,
            },
            departmentId: departmentId
          },
        },
        {
          $lookup: {
            from: 'departments',
            localField: 'departmentId',
            foreignField: '_id',
            as: 'department',
          },
        },
        {
          $unwind: '$department',
        },
        {
          $lookup: {
            from: 'images',
            localField: 'image',
            foreignField: '_id',
            as: 'imageData',
          },
        },
        {
          $addFields: {
            image: {
              $cond: {
                if: { $eq: [{ $size: '$imageData' }, 0] },
                then: null,
                else: { imageAddress: { $arrayElemAt: ['$imageData.imageAddress', 0] } },
              },
            },
            departmentId: {
              name: '$department.name',
            },
          },
        },
        {
          $project: {
            imageData: 0
          },
        },
        {
          $project: {
            department: 0,
          },
        },
      ];
    } else {
      pipeline = [
        {
          $lookup: {
            from: 'departments',
            localField: 'departmentId',
            foreignField: '_id',
            as: 'department',
          },
        },
        {
          $unwind: '$department',
        },
        {
          $lookup: {
            from: 'images',
            localField: 'image',
            foreignField: '_id',
            as: 'imageData',
          },
        },
        {
          $addFields: {
            image: {
              $cond: {
                if: { $eq: [{ $size: '$imageData' }, 0] },
                then: null,
                else: { imageAddress: { $arrayElemAt: ['$imageData.imageAddress', 0] } },
              },
            },
            departmentId: {
              name: '$department.name',
            },
          },
        },
        {
          $project: {
            imageData: 0
          },
        },
        {
          $project: {
            department: 0,
          },
        },
      ];
    }

    const result = await Course.aggregate(pipeline);

    req.aggregatedResults = result;

    next();
  } catch (error) {
    next(error);
  }
};

export default aggregateMiddleware