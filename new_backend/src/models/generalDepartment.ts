import { Document, Schema, model } from "mongoose";

export interface IGeneralDepartment extends Document {
//   id: Schema.Types.ObjectId;
  description: String;
  isForListing: Boolean
  name: String;
 
}

const GeneralDepartmentSchema: Schema<IGeneralDepartment> = new Schema({
  name:{
    type: String,
    required:[true,"General department name is required"]
  },
  isForListing: {
    type: Boolean,
    default: true
  },
  description: {
    type: String,
    required: false,
    default: ""
  }
},
{
    timestamps: {
      createdAt: 'createdAt',
      updatedAt: 'updatedAt'
    }
  }
);

const GeneralDepartment = model<IGeneralDepartment>("GeneralDepartment", GeneralDepartmentSchema);

export default GeneralDepartment;
