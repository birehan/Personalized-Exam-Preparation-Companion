import { Document, Schema, model, Types } from 'mongoose';

export interface IContentReviewDocument extends Document {
  subChapterContentId: Types.ObjectId;
  status: 'approved' | 'pending' | 'declined';
  reviewerId: Types.ObjectId;
  subChapterReviewId: Types.ObjectId;
  comment: String;
  requestedBy: Types.ObjectId;
}

const ContentReviewSchema: Schema<IContentReviewDocument> = new Schema(
  {
    subChapterContentId: {
      type: Schema.Types.ObjectId,
      ref: 'SubChapterContent',
      required: true,
    },
    subChapterReviewId: {
      type: Schema.Types.ObjectId,
      ref: 'SubChapterReview',
      required: true,
    },
    status: {
      type: String,
      enum: ['approved', 'pending', 'declined'],
      default: "pending",
    },
    reviewerId: {
      type: Schema.Types.ObjectId,
      ref: 'Reviewer',
      required: true,
    },
    comment: {
        type: String,
        default: "No comments!",
      },
    requestedBy: {
      type: Schema.Types.ObjectId,
      ref: 'Admin',
      default: null,
    },
  },
  {
    timestamps: {
      createdAt: 'createdAt',
      updatedAt: 'updatedAt',
    },
  }
);

const ContentReview = model<IContentReviewDocument>('ContentReview', ContentReviewSchema);

export default ContentReview;
