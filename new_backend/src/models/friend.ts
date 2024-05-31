import { Document, Schema, model } from "mongoose";

export interface IFriend extends Document {
  requestedBy: Schema.Types.ObjectId;
  receiver: Schema.Types.ObjectId;
  status: 'pending' | 'accepted' | 'declined';
}

const friendSchema: Schema<IFriend> = new Schema({
  requestedBy: {
    type: Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  receiver: {
    type: Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  status: {
    type: String,
    enum: ['pending', 'accepted', 'declined'],
    default: 'pending',
  }
},
{
  timestamps: {
    createdAt: 'createdAt',
    updatedAt: 'updatedAt'
  }
});

const Friend = model<IFriend>('Friend', friendSchema);

export default Friend;
