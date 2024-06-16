
import { Document, Schema, model } from "mongoose";

export interface IUserQuizScore extends Document {
//   id: Schema.Types.ObjectId;
  userId: Schema.Types.ObjectId;
  quizId: Schema.Types.ObjectId;
  completed: Boolean;
  score: Number;
}

const UserQuizScoreSchema: Schema<IUserQuizScore> = new Schema({
  quizId:{
    type: Schema.Types.ObjectId,
    ref: "Quiz",
    required:[true,"Course Id is required"]
  },
  userId: {
    type: Schema.Types.ObjectId,
    ref: "User",
    required:[true,"User Id is required"]
  },
  completed:{
    type:Boolean,
    default: true
  },
  score: {
    type: Number,
    default: 0
  },
},
{
    timestamps: {
      createdAt: 'createdAt',
      updatedAt: 'updatedAt'
    }
  }
);

const UserQuizScore = model<IUserQuizScore>("UserQuizScore", UserQuizScoreSchema);

export default UserQuizScore;
