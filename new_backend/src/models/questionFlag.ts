
import { Document, Schema, model } from "mongoose";

export interface IQuestionFlag extends Document {
    userId : Schema.Types.ObjectId,
    questionId : Schema.Types.ObjectId,
    comment : String,
    adminValidated: boolean;
}

const QuestionFlagSchema: Schema<IQuestionFlag> = new Schema({
    userId:{
    type: Schema.Types.ObjectId,
    ref: "User",
    required: [true,"User id is required"],
    },
    questionId: {
        type: Schema.Types.ObjectId, ref: "Question",
        required: [true, "Question id is required"]
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

const QuestionFlag = model<IQuestionFlag>("QuestionFlag", QuestionFlagSchema);

export default QuestionFlag;
