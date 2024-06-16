import { Document, Schema, model } from 'mongoose';

export interface IUserContestCategoryDocument extends Document {
  contestCategoryId: Schema.Types.ObjectId;
  userId: Schema.Types.ObjectId;
  score: number;
  isSubmitted: boolean;
}

const UserContestCategorySchema: Schema<IUserContestCategoryDocument> = new Schema(
  {
    contestCategoryId: {
      type: Schema.Types.ObjectId,
      ref: 'ContestCategory',
      required: [true, 'Contest Category Id is required'],
    },
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'User Id is required'],
    },
    score: {
      type: Number,
      default: 0,
    },
    isSubmitted: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: {
      createdAt: 'createdAt',
      updatedAt: 'updatedAt',
    },
  }
);

const UserContestCategory = model<IUserContestCategoryDocument>('UserContestCategory', UserContestCategorySchema);

export default UserContestCategory;
