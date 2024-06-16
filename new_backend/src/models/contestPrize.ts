import { Document, Schema, model } from 'mongoose';

export interface IContestPrizeDocument extends Document {
  prizeIds: Schema.Types.ObjectId[];
  contestId: Schema.Types.ObjectId;
}

const ContestPrizeSchema: Schema<IContestPrizeDocument> = new Schema(
  {
    prizeIds: [
      {
        type: Schema.Types.ObjectId,
        ref: 'Prize',
        required: [true, 'Prize Id is required'],
      },
    ],
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

const ContestPrize = model('ContestPrize', ContestPrizeSchema);

export default ContestPrize;
