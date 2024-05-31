import { Document, Schema, model } from "mongoose";

export interface IMock extends Document {
    name: String;
    subject: String;
    isStandard: Boolean;
    examYear: String;
    questions: [Schema.Types.ObjectId];
    departmentId: Schema.Types.ObjectId;
    adminApproval: Boolean;
  }

const mockSchema: Schema<IMock> = new Schema({
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
        ref: "Question"
    }],
      default: [],
    },
    departmentId: {
      type: Schema.Types.ObjectId,
      ref: 'Department',
      required: [true, "departmentId required."]
    },
    adminApproval:{
      type: Boolean,
      default: true
    }
  },
  {
    timestamps: {
      createdAt: 'createdAt',
      updatedAt: 'updatedAt'
    }
  });
  
  const Mock = model<IMock>('Mock', mockSchema);
  
  export default Mock;