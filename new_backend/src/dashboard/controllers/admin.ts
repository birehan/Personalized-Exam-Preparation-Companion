import { Request, Response, NextFunction } from 'express';
import { BaseResponse } from '../../types/baseResponse';
import { adminValidator, reviewerAdminValidator, reviwerValidator } from '../../validations/joiModelValidator';
import Admin from '../models/admin';
import ReviewerAdmin from '../models/reviewerAdmin';

export const updateAdminProfile = async (req: Request) => {
    try {
        const adminId = req.body.userDetails._id.toString();
        const { firstName, lastName, avatar } = req.body;
  
        const {error, value} = adminValidator({ firstName, lastName, avatar }, 'put');
        if (error) {
          throw error
        }
  
        const existingAdmin = await Admin.findOne({ _id: adminId}).exec();
  
        existingAdmin.firstName = value.firstName;
        existingAdmin.lastName = value.lastName;
        existingAdmin.avatar = value.avatar;
  
        const  userDetails = await existingAdmin.save();
  
        const updatedReviewer = await Admin.findOne({ _id: userDetails._id}).populate({ path: 'avatar', select: '-_id imageAddress',}).lean().exec();
  
        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'Admin profile details updated successfully!';
        baseResponse.data = updatedReviewer;
  
        return baseResponse;
    } catch (error) {
        throw error;
    }
  }

  export const updateReviewerAdminProfile = async (req: Request) => {
    try {
        const reviewerAdminId = req.body.userDetails._id.toString();
        const { firstName, lastName, avatar } = req.body;
  
        const {error, value} = reviewerAdminValidator({ firstName, lastName, avatar }, 'put');
        if (error) {
          throw error
        }
  
        const existingReviewerAdmin = await ReviewerAdmin.findOne({ _id: reviewerAdminId}).exec();
  
        existingReviewerAdmin.firstName = value.firstName;
        existingReviewerAdmin.lastName = value.lastName;
        existingReviewerAdmin.avatar = value.avatar;
  
        const  userDetails = await existingReviewerAdmin.save();
  
        const updatedReviewer = await ReviewerAdmin.findOne({ _id: userDetails._id}).populate({ path: 'avatar', select: '-_id imageAddress',}).lean().exec();
  
        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'Reviewer Admin profile details updated successfully!';
        baseResponse.data = updatedReviewer;
  
        return baseResponse;
    } catch (error) {
        throw error;
    }
  }