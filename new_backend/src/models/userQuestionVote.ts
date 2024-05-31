
import { Document, Schema, model } from "mongoose";

export interface IUserQuestionVote extends Document {
    userId : Schema.Types.ObjectId,
    questionId : Schema.Types.ObjectId,
    createdAt: Date
    updatedAt: Date
}

const UserQuestionVoteSchema: Schema<IUserQuestionVote> = new Schema({
    userId:{
    type: Schema.Types.ObjectId,
    ref: "User",
    required: [true,"User id is required"],
    },
    questionId: {
        type: Schema.Types.ObjectId, ref: "Question",
        required: [true, "Question id is required"]
    }
    },
    {
        timestamps: {
        createdAt: 'createdAt',
        updatedAt: 'updatedAt'
        }
    }
);

const UserQuestionVote = model<IUserQuestionVote>("UserQuestionVote", UserQuestionVoteSchema);

export default UserQuestionVote;
