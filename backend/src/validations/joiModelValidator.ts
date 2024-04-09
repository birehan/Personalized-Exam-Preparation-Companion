import Joi from "joi";
const requiredRule = { post: (schema) => schema.required(), put: (schema => schema.optional()) }



// Validator for department model
export const departmentValidator = (department, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    description: Joi.string(),
    name: Joi.string().alter(requiredRule),
    noOfCourses: Joi.number(),
  });
  return schema.tailor(requestType).validate(department, { abortEarly: false });
};
