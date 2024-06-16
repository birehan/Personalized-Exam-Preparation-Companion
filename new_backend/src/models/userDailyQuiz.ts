import { Document, Schema, model } from "mongoose";

export interface IUserDailyQuiz extends Document {
  dailyQuizId: Schema.Types.ObjectId;
  userId: Schema.Types.ObjectId;
  score: number;
}

const userDailyQuizSchema: Schema<IUserDailyQuiz> = new Schema({
  dailyQuizId: {
    type: Schema.Types.ObjectId,
    ref: "DailyQuiz",
    required: [true, "dailyQuizId required."]
  },
  userId: {
    type: Schema.Types.ObjectId,
    ref: "User",
    required: [true, "userId required."]
  },
  score: {
    type: Number,
    required: [true, "score required."],
    default: 0
  }
},
{
  timestamps: {
    createdAt: 'createdAt',
    updatedAt: 'updatedAt'
  }
});

const UserDailyQuiz = model<IUserDailyQuiz>('UserDailyQuiz', userDailyQuizSchema);

export default UserDailyQuiz;
