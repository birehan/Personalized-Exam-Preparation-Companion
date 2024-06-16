import {Request,Response,NextFunction} from 'express';
import VideoChannel from '../models/videoChannel';
import { videoChannelValidator } from '../validations/joiModelValidator';
import { BaseResponse } from '../types/baseResponse';
import { isValidObjectId } from '../services/helpers';
const createVideoChannel = async (req:Request,res:Response,next:NextFunction) => {
    try {
        const {channelName,channelType,channelUrl} = req.body;
        const userInput = {channelName,channelType,channelUrl}
        const result = videoChannelValidator(userInput,'post');
        if (result.error) throw result.error;
        const newChannel = await VideoChannel.create(result.value);
        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'Video Channel created successfully!';
        baseResponse.data = newChannel;
        res.status(201).json({...baseResponse});
    } catch (error) {
        next(error);
    }
}

const getVideoChannel = async (req:Request,res:Response,next:NextFunction) => {
    try {
        const channels = await VideoChannel.find().lean().exec();
        if (!channels) throw new Error('No Video Channels found!');
        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'Video Channels fetched successfully!';
        baseResponse.data = channels;
        res.status(200).json({...baseResponse});
    } catch (error) {
        next(error);
    }
}
const getVideoChannelById = async (req:Request,res:Response,next:NextFunction) => {
    try {
        const id = req.params.id;
        if (!isValidObjectId(id)) {
            throw new Error('Invalid Video Channel ID!');
        }
        const channel = await VideoChannel.findById(id).lean().exec();
        if (!channel) throw new Error('No Video Channel found with that ID!');
        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'Video Channel fetched successfully!';
        baseResponse.data = channel;
        res.status(200).json({...baseResponse});
    } catch (error) {   
        next(error);
    }
}

const updateVideoChannel = async (req:Request,res:Response,next:NextFunction) => {
    try {
        const id = req.params.id;
        if (!isValidObjectId(id)) {
            throw new Error('Invalid Video Channel ID!');
        }
        const {channelName,channelType,channelUrl} = req.body;
        if (!channelName && !channelType && !channelUrl) {
            throw new Error('Please provide at least one field to update!');
        }
        const userInput = {channelName,channelType,channelUrl}

        const result = videoChannelValidator(userInput,'put');
        if (result.error) throw result.error;
        const updatedChannel = await VideoChannel.findByIdAndUpdate(id,result.value,{new:true}).lean().exec();
        if (!updatedChannel) throw new Error('No Video Channel found with that ID!');
        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'Video Channel updated successfully!';
        baseResponse.data = updatedChannel;
        res.status(200).json({...baseResponse});
    } catch (error) {
        next(error);
    }
}

const deleteVideoChannel = async (req:Request,res:Response,next:NextFunction) => {
    try {
        const id = req.params.id;
        if (!isValidObjectId(id)) {
            throw new Error('Invalid Video Channel ID!');
        }
        const channel = await VideoChannel.findByIdAndDelete(id).lean().exec();
        if (!channel) throw new Error('No Video Channel found with that ID!');
        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'Video Channel deleted successfully!';
        baseResponse.data = channel;
        res.status(200).json({...baseResponse});
    } catch (error) {
        next(error);
    }
}

export default {
    createVideoChannel,
    getVideoChannel,
    getVideoChannelById,
    updateVideoChannel,
    deleteVideoChannel
}