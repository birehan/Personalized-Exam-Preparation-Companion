import Joi from "joi";
import { Schema } from "mongoose";

const requiredRule = { post: (schema) => schema.required(), put: (schema => schema.optional()) }

// Validator for department model
export const departmentValidator = (department, requestType: string) => {
    const schema = Joi.object({
      _id: Joi.forbidden(),
      description: Joi.string(),
      name: Joi.string().alter(requiredRule),
      noOfCourses: Joi.number(),
      generalDepartmentId:Joi.string().hex().length(24).alter(requiredRule)
    });
    return schema.tailor(requestType).validate(department, { abortEarly: false });
  };
