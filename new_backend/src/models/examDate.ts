
import { Document, Schema, model } from "mongoose";

export interface IExamDate extends Document {
//   id: Schema.Types.ObjectId;
  date: String;
}

const ExamDateSchema: Schema<IExamDate> = new Schema({
  date:{
    type: String,
    required:[true,"Exam Date is required"]
  }
},
{
    timestamps: {
      createdAt: 'createdAt',
      updatedAt: 'updatedAt'
    }
  }
);

const ExamDate = model<IExamDate>("ExamDate", ExamDateSchema);

export default ExamDate;
