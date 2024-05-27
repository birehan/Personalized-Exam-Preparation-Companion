import { Document, Schema, model } from "mongoose";
export interface ICourse extends Document {
//   id: Schema.Types.ObjectId;
name: String;
image: Schema.Types.ObjectId;
description: String;
noOfChapters: Number;
grade: Number;
curriculum: Boolean;
departmentId: Schema.Types.ObjectId;
referenceBook: String;
ECTS: Number;
}

const CourseSchema: Schema<ICourse> = new Schema(
{
  name: {
    type: String,
    required: [true, "Course name is required"],
  },
  image: {
    type: Schema.Types.ObjectId,
    ref: "Image",
    default: null,
    required: false,
  },
  description: {
    type: String,
    required: false,
    default: "",
  },
  noOfChapters: {
    type: Number,
    required: false,
    default: 0,
  },
  grade: {
    type: Number,
    required: false,
    default: 0,
  },
  curriculum:{
    type: Boolean,
    required: true,
    default: true
  },
  departmentId: {
    type: Schema.Types.ObjectId,
    ref: "Department",
    required: [true, "Department Id is required"],
  },
  referenceBook: {
    type: String,
    required: false,
    default: "No reference book."
  },
  ECTS: {
      type: Number,
      default:0
  },
},
{
  timestamps: {
    createdAt: "createdAt",
    updatedAt: "updatedAt",
  },
}
);

const Course = model<ICourse>("Course", CourseSchema);

export default Course;
