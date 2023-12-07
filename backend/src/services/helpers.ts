import mongoose from "mongoose";

export const isEmailOrPhoneNumber = (input: string) => {
  const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;

  const phoneRegex = /^\+\d{11,}$/;

  if (emailRegex.test(input)) {
    return "Email";
  } else if (phoneRegex.test(input)) {
    return "Phone Number";
  } else {
    return "Neither Email nor Phone Number";
  }
};

export const isValidObjectId = (id) => {
  return mongoose.Types.ObjectId.isValid(id);
};

export const strToBool = (str: string) => {
  return str.toLowerCase() === "true";
};
