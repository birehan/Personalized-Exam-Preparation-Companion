import { Document, Schema, model, Types } from 'mongoose';

export interface ISubChapterReviewDocument extends Document {
  subChapterId: Types.ObjectId;
  reviewerId: Types.ObjectId;
  status: 'approved' | 'pending' | 'denied';
  requestedBy: Types.ObjectId;
  chapterId: Types.ObjectId;
  courseId: Types.ObjectId;
}

const SubChapterReviewSchema: Schema<ISubChapterReviewDocument> = new Schema(
  {
    subChapterId: {
      type: Schema.Types.ObjectId,
      ref: 'SubChapter',
      required: true,
    },
    reviewerId: {
      type: Schema.Types.ObjectId,
      ref: 'Reviewer',
      required: true,
    },
    status: {
      type: String,
      enum: ['approved', 'pending', 'denied'],
      default: "pending",
    },
    requestedBy: {
      type: Schema.Types.ObjectId,
      ref: 'Admin',
      default: null
    },
    chapterId: {
      type: Schema.Types.ObjectId,
      ref: 'Chapter',
      required: true,
    },
    courseId: {
      type: Schema.Types.ObjectId,
      ref: 'Course',
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

const SubChapterReview = model<ISubChapterReviewDocument>('SubChapterReview', SubChapterReviewSchema);

export default SubChapterReview;
