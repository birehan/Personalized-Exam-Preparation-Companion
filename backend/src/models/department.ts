import { Document, Schema, model } from "mongoose";

export interface IDepartment extends Document {
  //   id: Schema.Types.ObjectId;
  description: String;
  name: String;
}

const DepartmentSchema: Schema<IDepartment> = new Schema(
  {
    name: {
      type: String,
      required: [true, "Department name is required"],
    },
    description: {
      type: String,
      required: false,
      default: "",
    },
  },
  {
    timestamps: {
      createdAt: "createdAt",
      updatedAt: "updatedAt",
    },
  }
);

const Department = model<IDepartment>("Department", DepartmentSchema);

export default Department;
