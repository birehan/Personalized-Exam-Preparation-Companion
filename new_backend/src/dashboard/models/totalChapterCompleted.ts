import { Document, Schema, model } from "mongoose";

export interface ITotalChapterCompleted extends Document {
  departmentId: Schema.Types.ObjectId;
  count: number;
  day: Date;
  subject: string;
}

const TotalChapterCompletedSchema: Schema<ITotalChapterCompleted> = new Schema({
  departmentId: {
    type: Schema.Types.ObjectId,
    ref: "Department",
    required: [true, "Department Id is required"],
  },
  count: {
    type: Number,
    default: 0,
  },
  day: {
    type: Date,
    required: [true, "Day is required"],
  },
  subject: {
    type: String,
    required: [true, "Subject is required"],
  },
},
{
  timestamps: {
    createdAt: 'createdAt',
    updatedAt: 'updatedAt'
  }
});

const TotalChapterCompleted = model<ITotalChapterCompleted>(
  "TotalChapterCompleted",
  TotalChapterCompletedSchema
);

export default TotalChapterCompleted;
