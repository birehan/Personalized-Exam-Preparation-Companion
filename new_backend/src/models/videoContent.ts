import { Document, Schema, model,ObjectId,Types } from "mongoose";

export interface IVideoContent extends Document {
    courseId: Schema.Types.ObjectId;
    chapterId: Schema.Types.ObjectId;
    subChapterId: Schema.Types.ObjectId;
    title: string;
    order: number;
    duration: string;
    link: string;
    thumbnail: string;
    videoChannelId: ObjectId;
}

const VideoContentSchema: Schema<IVideoContent> = new Schema({
    courseId: {
        type: Schema.Types.ObjectId,
        ref: 'Course',
        required: [true, "Course Id is required"]
    },
    chapterId: {
        type: Schema.Types.ObjectId,
        ref: 'Chapter',
        required: [true, "Chapter Id is required"]
    },
    subChapterId: {
        type: Schema.Types.ObjectId,
        ref: 'SubChapter',
        required: [true, "SubChapter Id is required"]
    },
    title: {
        type: String,
        required: [true, "Title is required"]
    },
    order: {
        type: Number,
        default: 0
    },
    duration: {
        type: String,
        default: "00:10:00"
    },
    link: {
        type: String,
        required: [true, "Link is required"]
    },
    thumbnail: {
        type: String,
        required: [true, "thumbnail is required"]
    },
    videoChannelId: {
        type: Types.ObjectId,
        ref: 'VideoChannel',
        required: [true, "Video Channel Id is required"]
    }
},
{
    timestamps: {
        createdAt: 'createdAt',
        updatedAt: 'updatedAt'
    }
});

const VideoContent = model<IVideoContent>("VideoContent", VideoContentSchema);

export default VideoContent;
