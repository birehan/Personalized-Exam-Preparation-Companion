import { Document, Schema, model } from "mongoose";

export interface IChapter extends Document {
    name: String;
    order: Number;
    description: String;
    summary: String;
    courseId: Schema.Types.ObjectId;
    noOfSubChapters: Number;
    adminApproval: Boolean;
}

const ChapterShema: Schema<IChapter> = new Schema({
    courseId: {
        type: Schema.Types.ObjectId,
        ref: 'Course',
        required: [true, "Course Id is required"]
    },
    name: {
        type: String,
        required: [true, "Chapter name is required"]
    },
    order:{
        type: Number,
        default: 0
    },
    description: {
        type: String,
        default: ""
    },
    summary: {
        type: String,
        required: [true, "Chapter summary is required"],
        default: ""
    },
    noOfSubChapters:{
        type: Number,
        default: 0
    },
    adminApproval: {
        type: Boolean,
        default: true
    }
},
    {
        timestamps: {
            createdAt: 'createdAt',
            updatedAt: 'updatedAt'
        }
    }
);

const Chapter = model<IChapter>("Chapter", ChapterShema);

export default Chapter;
