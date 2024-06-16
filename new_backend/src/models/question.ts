import { Document, Schema, model } from "mongoose";

export interface IQuestion extends Document {
  courseId: Schema.Types.ObjectId;
  description: String;
  choiceA: String;
  choiceB: String;
  choiceC: String;
  choiceD: String;
  answer: String;
  relatedTopic: String;
  explanation: String;
  adminApproval: Boolean
  isForQuiz: Boolean;
  isForMock: Boolean;
  chapterId:  Schema.Types.ObjectId;
  subChapterId:  Schema.Types.ObjectId;
}

const QuestionSchema: Schema<IQuestion> = new Schema({
  chapterId:{
    type:Schema.Types.ObjectId,
    ref:'Chapter',
    required:[true,"chapter Id is required"]
  },
  courseId:{
    type:Schema.Types.ObjectId,
    ref:'Course',
    required:[true,"course Id is required"]
  },
  subChapterId:{
    type:Schema.Types.ObjectId,
    ref:'SubChapter',
    required:[true,"SubChapter Id is required"]
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
  relatedTopic: {
    type: String,
    default: "No related topic for now!"
  },
  isForQuiz: {
    type: Boolean,
    default: true
  },
  isForMock: {
    type: Boolean,
    default: false
  },
  adminApproval:{
    type: Boolean,
    default: true
  }
},
{
    timestamps: {
      createdAt: 'createdAt',
      updatedAt: 'updatedAt'
    }
  }
);

const Question = model<IQuestion>("Question", QuestionSchema);

export default Question;
