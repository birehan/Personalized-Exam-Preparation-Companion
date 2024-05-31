import { Document, Schema, model } from "mongoose";

export interface ITelegramMock extends Document {
    name: String;
    subject: String;
    isStandard: Boolean;
    examYear: String;
    questions: [Schema.Types.ObjectId];
    departmentId: Schema.Types.ObjectId;
  }

const TelegramMockSchema: Schema<ITelegramMock> = new Schema({
    name: {
      type: String,
      default: 'New Quiz',
    },
    subject: {
      type: String,
      default: 'New Subject',
    },
    isStandard: {
      type: Boolean,
      default: false,
    },
    examYear: {
      type: String,
      default: '',
    },
    questions: {
      type: [{
        type: Schema.Types.ObjectId,
        ref: "TelegramQuestion"
    }],
      default: [],
    },
    departmentId: {
      type: Schema.Types.ObjectId,
      ref: 'Department',
      required: [true, "departmentId required."]
    },
  },
  {
    timestamps: {
      createdAt: 'createdAt',
      updatedAt: 'updatedAt'
    }
  });
  
  const TelegramMock = model<ITelegramMock>('TelegramMock', TelegramMockSchema);
  
  export default TelegramMock;