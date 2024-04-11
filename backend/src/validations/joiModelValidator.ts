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

// Validator for course model
export const courseValidator = (course, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    description: Joi.string(),
    image: Joi.string().hex().length(24),
    name: Joi.string().alter(requiredRule),
    noOfChapters: Joi.number(),
    departmentId: Joi.string().hex().length(24).alter(requiredRule),
    referenceBook: Joi.string(),
    ECTS: Joi.number(),
    curriculum: Joi.string()
  });
  return schema.tailor(requestType).validate(course, { abortEarly: false });
};