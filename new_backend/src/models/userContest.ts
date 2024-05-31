import { Document, Schema, model } from 'mongoose';

export interface IUserContestDocument extends Document {
  contestId: Schema.Types.ObjectId;
  userId: Schema.Types.ObjectId;
  startedAt: Date;
  finishedAt: Date;
  score: number;
  type: 'virtual' | 'live';
}

const UserContestSchema: Schema<IUserContestDocument> = new Schema(
  {
    contestId: {
      type: Schema.Types.ObjectId,
      ref: 'Contest',
      required: [true, 'Contest Id is required'],
    },
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'User Id is required'],
    },
    startedAt: {
      type: Date,
      required: true,
    },
    finishedAt: {
      type: Date,
      required: true,
    },
    score: {
      type: Number,
      default: 0,
    },
    type: {
      type: String,
      enum: ['virtual', 'live'],
      default: 'virtual',
    },
  },
  {
    timestamps: {
      createdAt: 'createdAt',
      updatedAt: 'updatedAt',
    },
  }
);

const UserContest = model<IUserContestDocument>('UserContest', UserContestSchema);

export default UserContest;