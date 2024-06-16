
import { Document, Schema, model } from "mongoose";

export interface IUserCourse extends Document {
//   id: Schema.Types.ObjectId;
    userId : Schema.Types.ObjectId,
    courses : [Schema.Types.ObjectId]
}

const UserCourseSchema: Schema<IUserCourse> = new Schema({
    userId:{
    type: Schema.Types.ObjectId,
    ref: "User",
    required: [true,"User id is required"],
  },
  courses: {
    type: [{ type: Schema.Types.ObjectId, ref: "Course" }],
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

const UserCourse = model<IUserCourse>("UserCourse", UserCourseSchema);

export default UserCourse;
