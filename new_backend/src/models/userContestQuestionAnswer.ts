import { Document, Schema, model } from 'mongoose';
import { QuestionAnswers } from './questionUserAnswer';

export interface IUserContestQuestionAnswerDocument extends Document {
  contestQuestionId: Schema.Types.ObjectId;
  userId: Schema.Types.ObjectId;
  userAnswer: string;
}

const UserContestQuestionAnswerSchema: Schema<IUserContestQuestionAnswerDocument> = new Schema(
  {
    contestQuestionId: {
      type: Schema.Types.ObjectId,
      ref: 'ContestQuestion',
      required: [true, 'Contest Question Id is required'],
    },
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'User Id is required'],
    },
    userAnswer: {
      type: String,
      enum: Object.values(QuestionAnswers),
      required: [true, 'User Answer is required'],
    },
  },
  {
    timestamps: {
      createdAt: 'createdAt',
      updatedAt: 'updatedAt',
    },
  }
);

const UserContestQuestionAnswer = model<IUserContestQuestionAnswerDocument>(
  'UserContestQuestionAnswer',
  UserContestQuestionAnswerSchema
);

export default UserContestQuestionAnswer;
