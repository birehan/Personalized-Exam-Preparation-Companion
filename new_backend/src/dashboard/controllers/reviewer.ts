import { Request, Response, NextFunction } from 'express';
import Joi from 'joi';
import { BaseResponse } from '../../types/baseResponse';
import Reviewer, {IReviewer} from '../models/reviewer';
import { reviwerValidator } from '../../validations/joiModelValidator';
import MockReview from '../models/mockReview';
import { Types } from 'mongoose';
import Mock, { IMock } from '../../models/mock';
import { updateAdminProfile, updateReviewerAdminProfile } from './admin';


const getReviewers = async (_req: Request, res: Response, next: NextFunction) => {
    try {
      const reviewers = await Reviewer.find();
      const baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Reviewers retrieved successfully';
      baseResponse.data = reviewers;
  
      return res.status(200).json({ ...baseResponse });
    } catch (error) {
     next(error)
    }
  };

  const getReviewer = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const reviewer = await Reviewer.findById(req.params.id);
      if (!reviewer) throw Error('Reviewer not found!')

      const baseResponse = new BaseResponse();
  
      baseResponse.success = true;
      baseResponse.message = 'Reviewer retrieved successfully';
      baseResponse.data = reviewer;
  
      return res.status(200).json({ ...baseResponse });
    } catch (error) {
      next(error)
    }
  };

const updateReviewer = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const {error, value} = reviwerValidator(req.body, 'put');
    if (error) {
      throw error
    }

    const updatedReviewer = await Reviewer.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!updatedReviewer) {
      throw Error('User not foud')
    }
    const baseResponse = new BaseResponse();
    
    baseResponse.success = true;
    baseResponse.message = 'Reviewer updated successfully';
    baseResponse.data = updatedReviewer;

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error)
  }
};

// export const deleteReviewer = async (req: Request, res: Response, next: NextFunction) => {
//   try {
//     const deletedReviewer = await Reviewer.findByIdAndDelete(req.params.id);
//     if (!deletedReviewer) {
//       return res.status(404).json({ error: 'Reviewer not found' });
//     }
//     return res.status(204).send();
//   } catch (error) {
//     console.error(error);
//     return res.status(500).json({ error: 'Internal Server Error' });
//   }
// };

const getMocksByReviewerId = async (req: Request, res: Response, next: NextFunction) => {
  try {

    //reviewer Id to be changed to the data fetched from middleware
    const reviewerId = req.body.userDetails._id;;

    const mockReviewes = await MockReview.aggregate([
      {
        $match: {
          reviewerId: reviewerId,
        },
      },
      {
        $lookup: {
          from: 'mocks',
          localField: 'mockId',
          foreignField: '_id',
          as: 'mock',
        },
      },
      {
        $unwind: '$mock',
      },
      {
        $project: {
          mockId: '$mock._id',
          status: '$status',
          createdAt: '$createdAt',
          updatedAt: '$updatedAt',
          questionCount: { $size: '$mock.questions' },
          name: '$mock.name',
          examYear: '$mock.examYear', 
          isStandard: '$mock.isStandard',
          subject: '$mock.subject'
        },
      },
    ]);
    const baseResponse = new BaseResponse();
    
    baseResponse.success = true;
    baseResponse.message = 'Reviewer assigned mockes fetched successfully!';
    baseResponse.data = mockReviewes;

    return res.status(200).json({ ...baseResponse });
    
  } catch (error) {
    next(error); 
  }
};

const getReviewersForMock = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { mockId } = req.params;

    // Fetch subject from Mock model using mockId
    const mock: IMock | null = await Mock.findById(mockId).exec();

    if (!mock) {
      throw Error('Invalid mock id!')
    }

    const mockSubject = mock.subject;

    // Fetch reviewers who can review the subject
    const reviewers: IReviewer[] = await Reviewer.find({ subject: { $in: mockSubject } }).exec();

    const baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Reviewers fetched successfully';
    baseResponse.data = reviewers
    

    return res.status(200).json(baseResponse);
  } catch (error) {
    next(error);
  }
};

const updateReviewerProfile = async (req: Request, res: Response, next: NextFunction) => {
  try {
      if (req.body.dashboardUser.role === "ADMIN"){

        const baseResponse = await updateAdminProfile(req)
        return res.status(200).json({...baseResponse});

      }else if (req.body.dashboardUser.role === "REVIEWER_ADMIN"){

        const baseResponse = await updateReviewerAdminProfile(req)
        return res.status(200).json({...baseResponse});

      }else if (req.body.dashboardUser.role === "REVIEWER"){
        const reviewerId = req.body.userDetails._id.toString();
        const { firstName, lastName, avatar } = req.body;

        const {error, value} = reviwerValidator({ firstName, lastName, avatar }, 'put');
        if (error) {
          throw error
        }

        const existingReviewer = await Reviewer.findOne({ _id: reviewerId}).exec();

        existingReviewer.firstName = value.firstName;
        existingReviewer.lastName = value.lastName;
        existingReviewer.avatar = value.avatar;

        const  userDetails = await existingReviewer.save();

        const updatedReviewer = await Reviewer.findOne({ _id: userDetails._id}).populate({ path: 'avatar', select: '-_id imageAddress',}).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'Reviewer profile details updated successfully!';
        baseResponse.data = updatedReviewer;

        return res.status(200).json({...baseResponse});
      } else {
        throw Error("Unknown user role sent")
      }
      
  } catch (error) {
      next(error);
  }
}


const reviewerController = {
    getReviewer,
    getReviewers,
    updateReviewer,
    getMocksByReviewerId,
    getReviewersForMock,
    updateReviewerProfile
}

export default reviewerController;