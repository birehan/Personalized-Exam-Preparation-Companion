import { Document, Schema, model } from "mongoose";

export interface IDailyQuiz extends Document {
  day: Date;
  description: string;
  departmentId: Schema.Types.ObjectId;
  questions: Schema.Types.ObjectId[];
}

const dailyQuizSchema: Schema<IDailyQuiz> = new Schema({
  day: {
    type: Date,
    unique: true,
    required: [true, "day required."]
  },
  description: {
    type: String,
    default: "Complete daily quiz to earn points!"
  },
  departmentId: {
    type: Schema.Types.ObjectId,
    ref: "Department",
    required: [true, "Department is required."]
  },
  questions: [{
    type: Schema.Types.ObjectId,
    ref: "Question"
  }]
},
{
  timestamps: {
    createdAt: 'createdAt',
    updatedAt: 'updatedAt'
  }
});

const DailyQuiz = model<IDailyQuiz>('DailyQuiz', dailyQuizSchema);

export default DailyQuiz;
