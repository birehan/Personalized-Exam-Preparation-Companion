import { Document, Schema, model, Types } from 'mongoose';

export interface IMockReviewDocument extends Document {
  mockId: Types.ObjectId;
  reviewerId: Types.ObjectId;
  status?: 'approved' | 'pending' | 'declined';
  requestedBy: Types.ObjectId;
}

const MockReviewSchema: Schema<IMockReviewDocument> = new Schema(
  {
    mockId: {
      type: Schema.Types.ObjectId,
      ref: 'Mock', 
      required: true,
    },
    reviewerId: {
      type: Schema.Types.ObjectId,
      ref: 'Reviewer', 
      required: true,
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
      updatedAt: 'updatedAt',
    },
  }
);

const MockReview = model<IMockReviewDocument>('MockReview', MockReviewSchema);

export default MockReview;