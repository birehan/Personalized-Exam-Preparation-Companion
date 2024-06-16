import { Document, Schema, model } from "mongoose";

export interface IAdmin extends Document {
  userId: Schema.Types.ObjectId;
  firstName: string;
  lastName: string;
  avatar: Schema.Types.ObjectId;
}

const AdminSchema: Schema<IAdmin> = new Schema({
  userId: {
    type: Schema.Types.ObjectId,
    required: [true, "User ID is required"],
  },
  firstName: {
    type: String,
    required: [true, "First Name is required"],
  },
  lastName: {
    type: String,
    required: [true, "Last Name is required"],
  },
  avatar: {
    type: Schema.Types.ObjectId,
    ref: 'Image',
    default: null,
    required: false
  },
},
{
  timestamps: {
    createdAt: 'createdAt',
    updatedAt: 'updatedAt'
  }
});

const Admin = model<IAdmin>("Admin", AdminSchema);

export default Admin;