import mongoose from "mongoose";
import Friend from "../models/friend";
import { BaseResponse } from "../types/baseResponse";
import { NextFunction, Request, Response } from "express";
import User from "../models/user";
import UserStatistics from "../models/userStatistics";


const sendFriendRequest = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { receiver } = req.body;
      const requestedBy = req.body.user._id.toString();
  
      if (!mongoose.Types.ObjectId.isValid(requestedBy) || !mongoose.Types.ObjectId.isValid(receiver)) {
        throw Error('Invalid user IDs')
      }
  
      const requestingUser = await User.findById(requestedBy);
      const receivingUser = await User.findById(receiver);
  
      if (!requestingUser || !receivingUser) {
        throw Error('No user found with the IDs Provided.')
      }
      if (receiver == requestedBy){
        throw Error("can't send request to your self!")
      }

      const existingFriends = await Friend.findOne({
        receiver,
        requestedBy,
        status: { $in: ['accepted', 'pending'] }
      });

      if(existingFriends){
        throw Error("You have already sent request!")
      }
  
      const friendRequest = new Friend({
        requestedBy,
        receiver,
        status: 'pending'
      });
  
      const savedFriendRequest = await friendRequest.save();
  
      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Friend request sent successfully!';
      baseResponse.data = {
        friendRequest: savedFriendRequest
      };
  
      return res.status(201).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };


 const acceptFriendRequest = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const friendId  = req.params.id;
        
      const userId = req.body.user._id.toString();

      if (!mongoose.Types.ObjectId.isValid(friendId)) {
        throw Error('Invalid friend request ID.')
      }
  
      const friendRequest = await Friend.findById(friendId);
  
      if (!friendRequest) {
        throw Error("Friend request not found.")
      }
  
      if (friendRequest.status !== 'pending') {
        throw Error("Friend request is not pending.")
      }

      if (friendRequest.receiver.toString() !== userId){
        throw Error('Request is not sent to this user please login with the right credential.')
      }
  
      friendRequest.status = 'accepted';
      const updatedFriendRequest = await friendRequest.save();
  
      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Friend request accepted successfully!';
      baseResponse.data = {
        friendRequest: updatedFriendRequest
      };
  
      return res.status(200).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };


  const rejectFriendRequest = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const friendId  = req.params.id;

      const userId = req.body.user._id.toString();
  
      if (!mongoose.Types.ObjectId.isValid(friendId)) {
        throw Error("Invalid friend request ID.");
      }
  
      const friendRequest = await Friend.findById(friendId);
  
      if (!friendRequest) {
        throw Error("Friend request not found.")
        
      }
  
      if (friendRequest.status !== 'pending') {
        throw Error("Friend request is not pending.");
      }
  
      if (friendRequest.receiver.toString() != userId){
        throw Error('Request is not sent to this user please login with the right credential.')
      }

      friendRequest.status = 'declined';
      const updatedFriendRequest = await friendRequest.save();
  
      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Friend request declined successfully!';
      baseResponse.data = {
        friendRequest: updatedFriendRequest
      };
  
      return res.status(200).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };


  const unfriendUser = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const friendId = req.params.id;
      const userId = req.body.user._id.toString(); 

      if (!mongoose.Types.ObjectId.isValid(friendId)) {
        throw Error("Invalid friend request ID.");
      }
  
      const friendRequest = await Friend.findById(friendId);
  
      if (!friendRequest) {
        throw Error("Friend request not found.");
      }
  
      if (friendRequest.requestedBy.toString() !== userId && friendRequest.receiver.toString() !== userId) {
        throw Error("You are not authorized to perform this action.");
      }
  
      await friendRequest.deleteOne();
  
      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'User unfriended successfully!';
  
      return res.status(200).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };


  const cancelFriendRequest = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const friendId = req.params.id;
      const userId = req.body.user._id.toString(); 
      if (!mongoose.Types.ObjectId.isValid(friendId)) {
        throw Error("Invalid friend request ID.");
      }
  
      const friendRequest = await Friend.findById(friendId);
  
      if (!friendRequest) {
        throw Error("Friend request not found.");
      }
  
      if (friendRequest.requestedBy.toString() !== userId) {
        throw Error("You are not authorized to cancel this friend request.");
      }
  
      await friendRequest.deleteOne();
  
      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Friend request canceled successfully!';
  
      return res.status(200).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };

  const getPendingFriendRequests = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const userId = req.body.user._id.toString(); 

      const pendingRequests = await Friend.find({ receiver: userId, status: 'pending' })
        .lean()
        .populate('requestedBy', '-password')
        .populate('receiver', '-password')
        .exec();
  
      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Pending friend requests retrieved successfully!';
      baseResponse.data = {
        pendingRequests
      };
  
      return res.status(200).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };

  const getSentPendingRequests = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const userId = req.body.user._id.toString(); 


      const sentRequests = await Friend.find({ requestedBy: userId, status: 'pending' })
        .lean()
        .populate('requestedBy', '-password')
        .populate('receiver', '-password')
        .exec();

        let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Pending friend requests sent by the user retrieved successfully!';
      baseResponse.data = {
        sentRequests
      };
  
      return res.status(200).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };

  const getFriends = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const userId = req.body.user._id.toString(); 
  
      const acceptedFriendRequests = await Friend.find({
        status: 'accepted',
        $or: [{ requestedBy: userId }, { receiver: userId }]
      })
        .lean()
        .exec();
  
  
      const friendsPromises = acceptedFriendRequests.map(async request => {
        const friendId = request.requestedBy.toString() === userId ? request.receiver : request.requestedBy;
        const friendDetails : any = await User.findById(friendId).select('-password').populate('avatar').lean().exec();
        const friendStatistics = await UserStatistics.findOne({ userId: friendId }).lean().exec();
        const friendAvatar = friendDetails?.avatar?.imageAddress;
  
        return {
          ...friendDetails,
          avatar: friendAvatar,
          points: friendStatistics ? friendStatistics.points : 0,
          maxStreak: friendStatistics ? friendStatistics.maxStreak : 0,
          currentStreak: friendStatistics ? friendStatistics.currentStreak : 0,
          isCurrentUser: false
        };
      });
  
      const friendsList = await Promise.all(friendsPromises);
  
  
      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Accepted friends retrieved successfully!';
      baseResponse.data = {
        friendsList
      };
  
      return res.status(200).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };
  const getFriendsWithRank = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const userId = req.body.user._id.toString(); 
      const acceptedFriendRequests = await Friend.find({
        status: 'accepted',
        $or: [{ requestedBy: userId }, { receiver: userId }]
      })
        .lean()
        .exec();
  
      let friends = await Promise.all(acceptedFriendRequests.map(async request => {
        const friendId = request.requestedBy.toString() === userId ? request.receiver : request.requestedBy;
        const friendDetails = await User.findById(friendId).select('-password').lean().exec();
        const userStatistics = await UserStatistics.findOne({ userId: friendId }).lean().exec();
  
        return {
          _id: request._id,
          friendDetail: {
            ...friendDetails,
            points: userStatistics ? userStatistics.points : 0,
            maxStreak: userStatistics ? userStatistics.maxStreak : 0,
            currentStreak: userStatistics ? userStatistics.currentStreak : 0,
            rank: 1
          },
          
        };
      }));
  
      const userDetail = await User.findById(userId).select('-password').lean().exec();
      const userStatistics = await UserStatistics.findOne({ userId }).lean().exec();

      friends.push({
        _id: userId,
        friendDetail: {
          ...userDetail,
          points: userStatistics ? userStatistics.points : 0,
          maxStreak: userStatistics ? userStatistics.maxStreak : 0,
          currentStreak: userStatistics ? userStatistics.currentStreak : 0,
          rank: 1
        },
      })
      friends.sort((a, b) => b.friendDetail.points - a.friendDetail.points);
  
      let rank = 1;
      for (let i = 0; i < friends.length; i++) {
        if (i > 0 && friends[i].friendDetail.points !== friends[i - 1].friendDetail.points) {
          rank = i + 1;
        }
        friends[i].friendDetail.rank = rank;
      }

      let currentUser={}

      friends= friends.filter(request=> {
        if (request._id === userId){
          currentUser= request.friendDetail
        }
        return request._id !== userId
      })
  
      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Accepted friends retrieved successfully!';
      baseResponse.data = {
        friends, 
        currentUser
      };
  
      return res.status(200).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };

  const searchUser = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const userId = new mongoose.Types.ObjectId(req.body.user._id);
      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 10;
      const search = req.query.search as string || '';
  
      const searchQuery: { [key: string]: any } = { _id: { $ne: userId } };
  
      if (search) {
        const regex = new RegExp(search, 'i');  // case-insensitive search
        searchQuery.$or = [
          { firstName: regex },
          { lastName: regex },
          { email_phone: regex },
          { $expr: { $regexMatch: { input: { $concat: ['$firstName', ' ', '$lastName'] }, regex: search, options: 'i' } } }
        ];
      }
  
      const usersPipeline: mongoose.PipelineStage[] = [
        {
          $match: searchQuery
        },
        {
          $lookup: {
            from: 'userstatistics',
            localField: '_id',
            foreignField: 'userId',
            as: 'statistics'
          }
        },
        {
          $unwind: {
            path: '$statistics',
            preserveNullAndEmptyArrays: true
          }
        },
        {
          $lookup: {
            from: 'friends',
            let: { userId: '$_id' },
            pipeline: [
              {
                $match: {
                  $expr: {
                    $or: [
                      { $and: [{ $eq: ['$requestedBy', userId] }, { $eq: ['$receiver', '$$userId'] }] },
                      { $and: [{ $eq: ['$requestedBy', '$$userId'] }, { $eq: ['$receiver', userId] }] }
                    ]
                  }
                }
              }
            ],
            as: 'friendship'
          }
        },
        {
          $addFields: {
            status: { $ifNull: [{ $arrayElemAt: ['$friendship.status', 0] }, 'none'] }
          }
        },
        {
          $lookup: {
            from: 'images',
            localField: 'avatar',
            foreignField: '_id',
            as: 'avatarImage'
          }
        },
        {
          $addFields: {
            avatarImage: { $ifNull: [{  $arrayElemAt: ['$avatarImage.imageAddress', 0] }, null] }
          }
        },
        {
          $project: {
            password: 0,
            friendship: 0,
            resetToken: 0
          }
        },
        {
          $sort: {
            'statistics.points': -1
          }
        },
        {
          $skip: (page - 1) * limit
        },
        {
          $limit: limit
        }
      ];
  
      const users = await User.aggregate(usersPipeline);
  
      const totalUsers = await User.countDocuments(searchQuery);
  
      const response = {
        success: true,
        message: 'Users with statistics and friends retrieved successfully!',
        data: {
          users,
          pagination: {
            total: totalUsers,
            page: page,
            pages: Math.ceil(totalUsers / limit)
          }
        }
      };
  
      return res.status(200).json(response);
    } catch (error) {
      next(error);
    }
  }
  

  export default {
    sendFriendRequest,
    acceptFriendRequest,
    unfriendUser,
    rejectFriendRequest, 
    cancelFriendRequest, 
    getPendingFriendRequests, 
    getSentPendingRequests,
    getFriendsWithRank,
    getFriends,
    searchUser
  }