import { Document, Schema, model } from "mongoose";

export interface IUserStatistics extends Document {
  userId: Schema.Types.ObjectId;
  maxStreak: number;
  currentStreak: number;
  points: number;
}

const UserStatisticsSchema: Schema<IUserStatistics> = new Schema({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: [true, "User Id is required"]
  },
  maxStreak: {
    type: Number,
    default: 0
  },
  currentStreak: {
    type: Number,
    default: 0
  },
  points: {
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

const UserStatistics = model<IUserStatistics>("UserStatistics", UserStatisticsSchema);

export default UserStatistics;
