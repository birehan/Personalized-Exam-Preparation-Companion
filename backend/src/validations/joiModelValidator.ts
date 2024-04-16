import Joi from "joi";
import { QuestionAnswers } from "../models/questionUserAnswer";

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

// Validator for chapter model
export const chapterValidator = (chapter, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    name: Joi.string().alter(requiredRule),
    order: Joi.number(),
    description: Joi.string(),
    summary: Joi.string().alter(requiredRule),
    courseId: Joi.string().hex().length(24).alter(requiredRule),
    noOfSubChapters: Joi.number(),
    adminApproval: Joi.boolean(),
  });
  return schema.tailor(requestType).validate(chapter, { abortEarly: false });
};

// Validator for subChapter model
export const subChapterValidator = (subChapter, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    name: Joi.string().alter(requiredRule),
    contents: Joi.array(),
    chapterId: Joi.string().hex().length(24).alter(requiredRule),
    adminApproval: Joi.boolean(),
    order: Joi.number()
  });
  return schema.tailor(requestType).validate(subChapter, { abortEarly: false });
};

// Validator for userCourse model
export const userCourseValidator = (userCourse, requestType:string) => {
  const schema = Joi.object({
    _id:Joi.forbidden(),
    userId: Joi.string().hex().length(24).alter(requiredRule),
    courses: Joi.array().items(Joi.string().hex().length(24)),
  });
  return schema.tailor(requestType).validate(userCourse, { abortEarly: false });
};

// Validator for question model
export const questionValidator = (question, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    description: Joi.string().alter(requiredRule),
    choiceA: Joi.string().alter(requiredRule),
    choiceB: Joi.string().alter(requiredRule),
    choiceC: Joi.string().alter(requiredRule),
    choiceD: Joi.string().alter(requiredRule),
    answer: Joi.string().alter(requiredRule),
    explanation: Joi.string().alter(requiredRule),
    relatedTopic: Joi.string(),
    adminApproval: Joi.boolean(),
    chapterId: Joi.string().hex().length(24).alter(requiredRule),
    courseId: Joi.string().hex().length(24).alter(requiredRule),
    subChapterId: Joi.string().hex().length(24).alter(requiredRule)
  });
  return schema.tailor(requestType).validate(question, { abortEarly: false });
};

// Validator for quiz model
export const quizValidator = (quiz, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    name: Joi.string().alter(requiredRule),
    numOfQuestion: Joi.number().min(1).alter(requiredRule),
    chapters: Joi.array().items(Joi.string().hex().length(24)).alter(requiredRule),
    courseId: Joi.string().hex().length(24).alter(requiredRule),
    userId: Joi.string().hex().length(24).alter(requiredRule)
  });
  return schema.tailor(requestType).validate(quiz, { abortEarly: false });
};

// Validator for questionUserAnswer model
export const questionUserAnswerValidator = (subChapterContent, requestType:string) => {
  const schema = Joi.object({
    _id:Joi.forbidden(),
    questionId: Joi.string().hex().length(24).alter(requiredRule),
    userId: Joi.string().hex().length(24).alter(requiredRule),
    userAnswer: Joi.string().valid(...Object.values(QuestionAnswers)).alter(requiredRule),
  });
  return schema.tailor(requestType).validate(subChapterContent, { abortEarly: false });
};

// Validator for subChapterContent model
export const subChapterContentValidator = (subChapterContent, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    title: Joi.string().alter(requiredRule),
    content: Joi.string().alter(requiredRule),
    order: Joi.number(),
    subChapterId: Joi.string().hex().length(24).alter(requiredRule)
  });


  return schema.tailor(requestType).validate(subChapterContent, { abortEarly: false });
};