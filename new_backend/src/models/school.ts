import { Document, Schema, model } from "mongoose";
import Joi, { string, object } from "joi";
import { RegionEnum } from "../types/typeEnum";


export interface ISchool extends Document {
  name: string;
  region: RegionEnum;
}

const SchoolSchema: Schema<ISchool> = new Schema(
  {
    name: {
      type: String,
      required: [true, "Name is required"],
    },
    region: {
      type: String,
      enum: Object.values(RegionEnum),
      required: [true, "Region is required"],
    },
  },
  {
    timestamps: {
      createdAt: "createdAt",
      updatedAt: "updatedAt",
    },
  }
);

const School = model<ISchool>("School", SchoolSchema);
export default School;
