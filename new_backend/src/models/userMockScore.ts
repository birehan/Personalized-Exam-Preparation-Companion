
import { Document, Schema, model } from "mongoose";

export interface IUserMockScore extends Document {
//   id: Schema.Types.ObjectId;
  userId: Schema.Types.ObjectId;
  mockId: Schema.Types.ObjectId;
  completed: Boolean;
  score: Number;
}

const UserMockScoreSchema: Schema<IUserMockScore> = new Schema({
    mockId:{
    type: Schema.Types.ObjectId,
    ref: "Mock",
    required:[true,"Mock Id is required"]
  },
  userId: {
    type: Schema.Types.ObjectId,
    ref: "User",
    required:[true,"User Id is required"]
  },
  completed:{
    type:Boolean,
    default: true
  },
  score: {
    type: Number,
    default: 0
  },
},
{
    timestamps: {
      createdAt: 'createdAt',
      updatedAt: 'updatedAt'
    }
  }
);

const UserMockScore = model<IUserMockScore>("UserMockScore", UserMockScoreSchema);

export default UserMockScore;
