import { Document, Schema, model } from 'mongoose';
import { PrizeType } from '../types/typeEnum';

export interface IPrizeDocument extends Document {
  standing: number;
  description: string;
  type: PrizeType;
  amount: number;
}

const PrizeSchema: Schema<IPrizeDocument> = new Schema(
  {
    standing: {
      type: Number,
      required: [true, 'Standing is required'],
    },
    description: {
      type: String,
      required: [true, 'Description is required'],
    },
    type: {
      type: String,
      enum: Object.values(PrizeType),
      required: [true, 'Type is required'],
    },
    amount: {
      type: Number,
      required: [true, 'Amount is required'],
    },
  },
  {
    timestamps: {
      createdAt: 'createdAt',
      updatedAt: 'updatedAt',
    },
  }
);

const Prize = model<IPrizeDocument>('Prize', PrizeSchema);

export default Prize;
