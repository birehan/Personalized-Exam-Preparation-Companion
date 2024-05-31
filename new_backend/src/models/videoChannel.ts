import {model,Model,Schema,Document} from 'mongoose';

export  interface IvideoChannel extends Document {
    channelName: string;
    channelUrl: string;
    channelType: string;
    createdAt: Date;
    updatedAt: Date;
    }


const videoChannelSchema:Schema<IvideoChannel> = new Schema({
    channelName: {
        type: String,
        required: [true, "Channel Name is required"]
    },
    channelUrl: {
        type: String,
        required: [true, "Channel URL is required"]
    },
    channelType: {
        type: String,
        default: "youtube"
    }
},
{
    timestamps: {
        createdAt: 'createdAt',
        updatedAt: 'updatedAt'
    }
});
export default model<IvideoChannel>("VideoChannel", videoChannelSchema);