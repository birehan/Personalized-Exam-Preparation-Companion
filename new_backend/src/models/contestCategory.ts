import { Document, Schema, model } from 'mongoose';
import { Subject } from '../types/typeEnum';


export interface IContestCategoryDocument extends Document {
  title: string;
  subject: Subject;
  contestId: Schema.Types.ObjectId;
}

const ContestCategorySchema: Schema<IContestCategoryDocument> = new Schema(
  {
    title: {
      type: String,
      required: [true, 'Title is required'],
    },
    subject: {
      type: String,
      enum: Object.values(Subject),
      required: [true, 'Subject is required'],
    },
    contestId: {
      type: Schema.Types.ObjectId,
      ref: 'Contest',
      required: [true, 'Contest Id is required'],
    },
  },
  {
    timestamps: {
      createdAt: 'createdAt',
      updatedAt: 'updatedAt',
    },
  }
);

const ContestCategory = model<IContestCategoryDocument>('ContestCategory', ContestCategorySchema);

export default ContestCategory;
