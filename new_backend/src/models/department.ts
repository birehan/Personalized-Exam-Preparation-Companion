
import { Document, Schema, model } from "mongoose";

export interface IDepartment extends Document {
//   id: Schema.Types.ObjectId;
  description: String;
  name: String;
  noOfCourses: Number;
  generalDepartmentId: Schema.Types.ObjectId;
}

const DepartmentSchema: Schema<IDepartment> = new Schema({
  name:{
    type: String,
    required:[true,"Department name is required"]
  },
  description: {
    type: String,
    required: false,
    default: ""
  },
  noOfCourses: {
    type: Number,
    required: false,
    default: 0
  },
  generalDepartmentId:{
    type:Schema.Types.ObjectId,
    ref:"GeneralDepartment",
    required:[true, "General department Id is required"]

  }

},
{
    timestamps: {
      createdAt: 'createdAt',
      updatedAt: 'updatedAt'
    }
  }
);

const Department = model<IDepartment>("Department", DepartmentSchema);

export default Department;
