import mongoose from "mongoose";

export const isValidObjectId = (id) => {
  return mongoose.Types.ObjectId.isValid(id);
};

export const strToBool = (str: string) => {
  return str.toLowerCase() === "true";
};

export const logActiveUser = async (userId: string, departmentId: string) => {
  const today = new Date();
  const startOfDay = new Date(today.getFullYear(), today.getMonth(), today.getDate());
  const filter = { day: startOfDay, departmentId:  departmentId};
  const update = { $addToSet: { uniqueUserIds: userId } };
  return true
}
