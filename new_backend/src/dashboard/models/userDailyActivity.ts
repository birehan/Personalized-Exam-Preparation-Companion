import { Document, Schema, model } from "mongoose";


export interface IUserDailyActivity extends Document {
  userId: Schema.Types.ObjectId;
  day: Date;
  quizCompleted: number;
  chapterCompleted: number;
  subchapterCompleted: number;
  mockCompleted: number;
  questionCompleted: number;
  questionChatCompleted: number;
  contentChatCompleted: number;
  dailyQuizCompleted: number;
  contestCompleted: number;
  videoCompleted: number;
}

const UserDailyActivitySchema: Schema<IUserDailyActivity> = new Schema({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: [true, "User Id is required"]
  },
  day: {
    type: Date,
    required: true
  },
  quizCompleted: {
    type: Number,
    default: 0
  },
  chapterCompleted: {
    type: Number,
    default: 0
  },
  subchapterCompleted: {
    type: Number,
    default: 0
  },
  mockCompleted: {
    type: Number,
    default: 0
  },
  questionCompleted: {
    type: Number,
    default: 0
  },
  questionChatCompleted: {
    type: Number,
    default: 0
  },
  contentChatCompleted: {
    type: Number,
    default: 0
  },
  dailyQuizCompleted: {
    type: Number,
    default: 0
  },
  contestCompleted: {
    type: Number,
    default: 0
  },
  videoCompleted: {
    type: Number,
    default: 0
  }
},
  {
    timestamps: {
      createdAt: 'createdAt',
      updatedAt: 'updatedAt'
    }
  }
);

const UserDailyActivity = model<IUserDailyActivity>("UserDailyActivity", UserDailyActivitySchema);

export default UserDailyActivity;
