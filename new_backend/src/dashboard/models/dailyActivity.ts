import { Schema, Document, Model, model } from 'mongoose';

export interface IDailyActivityDocument extends Document {
  day: Date;
  departmentId: string;
  uniqueUserIds: [Schema.Types.ObjectId];
}

interface DailyActivityModel extends Model<IDailyActivityDocument> {}

const DailyActivitySchema: Schema<IDailyActivityDocument, DailyActivityModel> = new Schema(
  {
    day: {
      type: Date,
      required: true,
    },
    departmentId: {
      type: String,
      required: true,
    },
    uniqueUserIds: {
        type: [{ type: Schema.Types.ObjectId, ref: "User" }],
        default: []
    },
  },
  {
    timestamps: true,
  }
);

const DailyActivity = model<IDailyActivityDocument, DailyActivityModel>('DailyActivity', DailyActivitySchema);

export default DailyActivity;