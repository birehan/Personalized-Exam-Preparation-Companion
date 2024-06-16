
import { Document, Schema, model } from "mongoose";

export interface IUserMock extends Document {
//   id: Schema.Types.ObjectId;
    userId : Schema.Types.ObjectId,
    mocks : [Schema.Types.ObjectId]
}

const UserMockSchema: Schema<IUserMock> = new Schema({
    userId:{
    type: Schema.Types.ObjectId,
    ref: "User",
    required: [true,"User id is required"],
  },
  mocks: {
    type: [{ type: Schema.Types.ObjectId, ref: "Mock" }],
    default: []
  },

},
{
    timestamps: {
      createdAt: 'createdAt',
      updatedAt: 'updatedAt'
    }
  }
);

const UserMock = model<IUserMock>("UserMock", UserMockSchema);

export default UserMock;
