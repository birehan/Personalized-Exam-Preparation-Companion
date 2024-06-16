
import { Document, Schema, model } from "mongoose";

export interface IUserCourseAnalysis extends Document {
//   id: Schema.Types.ObjectId;
  userId: Schema.Types.ObjectId;
  courseId: Schema.Types.ObjectId;
  completedChapters: [Schema.Types.ObjectId];
}

const UserCourseAnalysisSchema: Schema<IUserCourseAnalysis> = new Schema({
  courseId:{
    type: Schema.Types.ObjectId,
    ref: "Course",
    required:[true,"Course Id is required"]
  },
  userId: {
    type: Schema.Types.ObjectId,
    ref: "User",
    required:[true,"User Id is required"]
  },
  completedChapters: {
    type: [{
      type: Schema.Types.ObjectId, 
      ref: "Chapter" }],
    default: []
  },

},
{
    timestamps: {
      createdAt: 'createdAt',
      updatedAt: 'updatedAt'
    }
  }
);

const UserCourseAnalysis = model<IUserCourseAnalysis>("UserCourseAnalysis", UserCourseAnalysisSchema);

export default UserCourseAnalysis;
