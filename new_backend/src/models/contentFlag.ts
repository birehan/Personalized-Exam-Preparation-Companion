
import { Document, Schema, model } from "mongoose";

export interface IContentFlag extends Document {
    userId : Schema.Types.ObjectId,
    subChapterContentId : Schema.Types.ObjectId,
    comment : String,
    adminValidated: boolean
}

const ContentFlagSchema: Schema<IContentFlag> = new Schema({
    userId:{
    type: Schema.Types.ObjectId,
    ref: "User",
    required: [true,"User id is required"],
    },
    subChapterContentId: {
        type: Schema.Types.ObjectId, ref: "SubChapterContent",
        required: [true, "subChapterContent id is required"]
    },
    comment:{
        type:String,
        default: "No comments given"
    },
    adminValidated: {
        type: Boolean,
        default: false // Set the default value to false
    }
    },
    {
        timestamps: {
        createdAt: 'createdAt',
        updatedAt: 'updatedAt'
        }
    }
);

const ContentFlag = model<IContentFlag>("ContentFlag", ContentFlagSchema);

export default ContentFlag;
