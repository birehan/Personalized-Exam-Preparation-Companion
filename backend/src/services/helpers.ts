import mongoose from "mongoose";

export const isValidObjectId = (id) => {
  return mongoose.Types.ObjectId.isValid(id);
};

export const strToBool = (str: string) => {
  return str.toLowerCase() === "true";
};
