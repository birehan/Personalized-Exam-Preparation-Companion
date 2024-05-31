import { Document, Schema, model } from "mongoose";
import { Subject } from "../../types/typeEnum";

export interface IReviewer extends Document {
  userId: Schema.Types.ObjectId;
  firstName: string;
  lastName: string;
  avatar: Schema.Types.ObjectId;
  subject: Subject[];
}

const ReviewerSchema: Schema<IReviewer> = new Schema({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'DashboardUser',
    required: [true, "User ID is required"],
    unique: [true,  "This is a registerd reviewer"]
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
  subject: {
    type: [String],
    enum: Object.values(Subject),
    required: [true, "Subject is required"],
  },
},
{
  timestamps: {
    createdAt: 'createdAt',
    updatedAt: 'updatedAt'
  }
});

const Reviewer = model<IReviewer>("Reviewer", ReviewerSchema);

export default Reviewer