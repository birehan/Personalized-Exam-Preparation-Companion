import { Document, Schema, model, Types } from "mongoose";

export interface IQuestionReview extends Document {
  questionId: Schema.Types.ObjectId;
  reviewerId: Schema.Types.ObjectId;
  comment: string;
  status: 'approved' | 'pending' | 'declined';
  requestedBy: Types.ObjectId;
  mockReviewId?: Schema.Types.ObjectId;
}

const QuestionReviewSchema: Schema<IQuestionReview> = new Schema({
  questionId: {
    type: Schema.Types.ObjectId,
    ref: 'Question',
    required: [true, "Question Id is required"],
  },
  reviewerId: {
    type: Schema.Types.ObjectId,
    ref: 'Reviewer',
    required: [true, "Reviewer Id is required"],
  },
  mockReviewId: {
    type: Schema.Types.ObjectId,
    ref: 'MockReview',
    required: [true, "Mock review Id is required"],
  },
  comment: {
    type: String,
    default: "No comments!",
  },
  status: {
    type: String,
    enum: ['approved', 'pending', 'declined'],
    default: 'pending', 
  },
  requestedBy: {
    type: Schema.Types.ObjectId,
    ref: 'Admin',
    required: true,
  },
  
},
{
  timestamps: {
    createdAt: 'createdAt',
    updatedAt: 'updatedAt'
  }
});

const QuestionReview = model<IQuestionReview>(
  "QuestionReview",
  QuestionReviewSchema
);

export default QuestionReview;