import { Document, Schema, model } from 'mongoose';

export interface IContestQuestion extends Document {
  courseId: Schema.Types.ObjectId;
  description: string;
  choiceA: string;
  choiceB: string;
  choiceC: string;
  choiceD: string;
  answer: string;
  relatedTopic: string;
  explanation: string;
  chapterId: Schema.Types.ObjectId;
  subChapterId: Schema.Types.ObjectId;
  questionId: Schema.Types.ObjectId;
  contestCategoryId: Schema.Types.ObjectId;
  difficulty: Number;
}

const ContestQuestionSchema: Schema<IContestQuestion> = new Schema(
  {
    contestCategoryId: {
      type: Schema.Types.ObjectId,
      ref: 'ContestCategory',
      required: [true, 'ContestCategory Id is required'],
    },
    chapterId: {
      type: Schema.Types.ObjectId,
      ref: 'Chapter',
      required: [true, 'chapter Id is required'],
    },
    questionId: {
      type: Schema.Types.ObjectId,
      ref: 'Question',
      default: null,
    },
    courseId: {
      type: Schema.Types.ObjectId,
      ref: 'Course',
      required: [true, 'course Id is required'],
    },
    subChapterId: {
      type: Schema.Types.ObjectId,
      ref: 'SubChapter',
      required: [true, 'SubChapter Id is required'],
    },
    description: {
      type: String,
      required: [true, 'question description is required'],
    },
    choiceA: {
      type: String,
      required: [true, 'choice A is required'],
    },
    choiceB: {
      type: String,
      required: [true, 'choice B is required'],
    },
    choiceC: {
      type: String,
      required: [true, 'choice C is required'],
    },
    choiceD: {
      type: String,
      required: [true, 'choice D is required'],
    },
    answer: {
      type: String,
      required: [true, 'Answer is required'],
    },
    explanation: {
      type: String,
      required: [true, 'explanation is required'],
    },
    relatedTopic: {
      type: String,
      default: 'No related topic for now!',
    },
    difficulty: {
      type: Number,
      default: 5,
    },
  },
  {
    timestamps: {
      createdAt: 'createdAt',
      updatedAt: 'updatedAt',
    },
  }
);

const ContestQuestion = model<IContestQuestion>('ContestQuestion', ContestQuestionSchema);

export default ContestQuestion;
