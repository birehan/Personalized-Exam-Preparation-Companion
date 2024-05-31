import { Document, Schema, model } from 'mongoose';

export interface IDailyQuest extends Document {
  day: Date;
  topic: number;
  dailyQuiz: number;
  quiz: number;
  mock: number;
  contest: number;
  departmentId: Schema.Types.ObjectId;
}

const dailyQuestSchema: Schema<IDailyQuest> = new Schema({
  day: {
    type: Date,
    required: true,
  },
  topic: {
    type: Number,
    default: 0,
  },
  dailyQuiz: {
    type: Number,
    default: 0,
  },
  quiz: {
    type: Number,
    default: 0,
  },
  mock: {
    type: Number,
    default: 0,
  },
  contest: {
    type: Number,
    default: 0,
  },
  departmentId: {
    type: Schema.Types.ObjectId,
    ref: "Department",
    required: [true, "Department is required."]
  },
});

const DailyQuest = model<IDailyQuest>('DailyQuest', dailyQuestSchema);

export default DailyQuest;
