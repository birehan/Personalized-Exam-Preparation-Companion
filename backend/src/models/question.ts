import { Document, Schema, model } from "mongoose";

export interface IQuestion extends Document {
  departmentId: Schema.Types.ObjectId;
  courseId: Schema.Types.ObjectId;
  chapterId: Schema.Types.ObjectId;
  subChapterId: Schema.Types.ObjectId;
  
  description: String;
  subject: String;
  choiceA: String;
  choiceB: String;
  choiceC: String;
  choiceD: String;
  answer: String;
  relatedTopic: String;
  explanation: String;
  year: Number;
  difficulty: Number;
}

const QuestionSchema: Schema<IQuestion> = new Schema(
  {
    departmentId: {
      type: Schema.Types.ObjectId,
      ref: "Department",
      required: [true, "department Id is required"],
    },
    chapterId: {
      type: Schema.Types.ObjectId,
      ref: "Chapter",
      required: [true, "chapter Id is required"],
    },
    courseId: {
      type: Schema.Types.ObjectId,
      ref: "Course",
      required: [true, "course Id is required"],
    },
    subChapterId: {
      type: Schema.Types.ObjectId,
      ref: "SubChapter",
      required: [true, "SubChapter Id is required"],
    },
    description: {
      type: String,
      required: [true, "question description is required"],
    },
    choiceA: {
      type: String,
      required: [true, "choice A is required"],
    },
    choiceB: {
      type: String,
      required: [true, "choice B is required"],
    },
    choiceC: {
      type: String,
      required: [true, "choice C is required"],
    },
    choiceD: {
      type: String,
      required: [true, "choice D is required"],
    },
    answer: {
      type: String,
      required: [true, "Answer is required"],
    },
    explanation: {
      type: String,
      required: [true, "explanation is required"],
    },
    difficulty: {
      type:Number,
      default: 1
    },
    subject:{
      type: String,
      required: [true, "subject is required"],
    },
    year: {
      type:Number,
      required: [true, "year is required"],
    }
  },
  {
    timestamps: {
      createdAt: "createdAt",
      updatedAt: "updatedAt",
    },
  }
);

const Question = model<IQuestion>("Question", QuestionSchema);

export default Question;
