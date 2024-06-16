import { Document, Schema, model } from "mongoose";

export interface IUserVideoAnalysis extends Document {
  userId: Schema.Types.ObjectId;
  videoId: Schema.Types.ObjectId;
  completed: boolean;
}

const UserVideoAnalysisSchema: Schema<IUserVideoAnalysis> = new Schema({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: [true, "User Id is required"]
  },
  videoId: {
    type: Schema.Types.ObjectId,
    ref: 'VideoContent',
    required: [true, "Video Id is required"]
  },
  completed: {
    type: Boolean,
    default: false
  }
},
{
  timestamps: {
    createdAt: 'createdAt',
    updatedAt: 'updatedAt'
  }
});

const UserVideoAnalysis = model<IUserVideoAnalysis>("UserVideoAnalysis", UserVideoAnalysisSchema);

export default UserVideoAnalysis;
