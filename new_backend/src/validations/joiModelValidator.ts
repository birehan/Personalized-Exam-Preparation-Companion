import Joi from "joi";
import { Schema } from "mongoose";
import { QuestionAnswers } from "../models/questionUserAnswer";
import { PrizeType, RegionEnum, Subject } from "../types/typeEnum";
import videoChannel from "../models/videoChannel";

const requiredRule = { post: (schema) => schema.required(), put: (schema => schema.optional()) }

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
    isForQuiz: Joi.boolean(),
    adminApproval: Joi.boolean(),
    chapterId: Joi.string().hex().length(24).alter(requiredRule),
    courseId: Joi.string().hex().length(24).alter(requiredRule),
    subChapterId: Joi.string().hex().length(24).alter(requiredRule)
  });
  return schema.tailor(requestType).validate(question, { abortEarly: false });
};

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

export const mockValidator = (mock, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    name: Joi.string().alter(requiredRule),
    subject: Joi.string().alter(requiredRule),
    isStandard: Joi.boolean().alter(requiredRule),
    examYear: Joi.string().alter(requiredRule),
    departmentId: Joi.string().hex().length(24).alter(requiredRule),
    questions: Joi.array().items(Joi.string().hex().length(24)).alter(requiredRule)
  });
  return schema.tailor(requestType).validate(mock, { abortEarly: false });
};
export const subChapterContentValidator = (subChapterContent, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    title: Joi.string().alter(requiredRule),
    content: Joi.string().alter(requiredRule),
    adminApproval: Joi.boolean().alter(requiredRule),
    order: Joi.number(),
    subChapterId: Joi.string().hex().length(24).alter(requiredRule)
  });
  return schema.tailor(requestType).validate(subChapterContent, { abortEarly: false });
};

export const userChapterAnalysisValidator = (userSubChapterAnalysis, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    userId: Joi.string().hex().length(24).alter(requiredRule),
    chapterId: Joi.string().hex().length(24).alter(requiredRule),
    completedSubChapters: Joi.array().items(Joi.string().hex().length(24)).alter(requiredRule)
  });
  return schema.tailor(requestType).validate(userSubChapterAnalysis, { abortEarly: false });
};

export const questionUserAnswerValidator = (subChapterContent, requestType:string) => {
  const schema = Joi.object({
    _id:Joi.forbidden(),
    questionId: Joi.string().hex().length(24).alter(requiredRule),
    userId: Joi.string().hex().length(24).alter(requiredRule),
    userAnswer: Joi.string().valid(...Object.values(QuestionAnswers)).alter(requiredRule),
  });
  return schema.tailor(requestType).validate(subChapterContent, { abortEarly: false });
};
export const userCourseAnalysisValidator = (userCourseAnalysis, requestType:string) => {
  const schema = Joi.object({
    _id:Joi.forbidden(),
    userId: Joi.string().hex().length(24).alter(requiredRule),
    courseId: Joi.string().hex().length(24).alter(requiredRule),
    completedChapters: Joi.array().items(Joi.string().hex().length(24)),
  });
  return schema.tailor(requestType).validate(userCourseAnalysis, { abortEarly: false });
};

//General department validator
export const generalDepartmentValidator = (generalDepartment, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    description: Joi.string(),
    isForListing: Joi.boolean(),
    name: Joi.string().alter(requiredRule),
  });
  return schema.tailor(requestType).validate(generalDepartment, { abortEarly: false });
};

//General department validator
export const examDateValidator = (examDate, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    date: Joi.string().alter(requiredRule),
  });
  return schema.tailor(requestType).validate(examDate, { abortEarly: false });
};

export const userCourseValidator = (userCourse, requestType:string) => {
  const schema = Joi.object({
    _id:Joi.forbidden(),
    userId: Joi.string().hex().length(24).alter(requiredRule),
    courses: Joi.array().items(Joi.string().hex().length(24)),
  });
  return schema.tailor(requestType).validate(userCourse, { abortEarly: false });
};

export const userQuizScoreValidator = (userQuizScore, requestType:string) => {
  const schema = Joi.object({
    _id:Joi.forbidden(),
    userId: Joi.string().hex().length(24).alter(requiredRule),
    quizId: Joi.string().hex().length(24).alter(requiredRule),
    score: Joi.number().min(0).default(0)
  });
  return schema.tailor(requestType).validate(userQuizScore, { abortEarly: false });
};

export const userMockScoreValidator = (userQuizScore, requestType:string) => {
  const schema = Joi.object({
    _id:Joi.forbidden(),
    userId: Joi.string().hex().length(24).alter(requiredRule),
    mockId: Joi.string().hex().length(24).alter(requiredRule),
    score: Joi.number().min(0).default(0)
  });
  return schema.tailor(requestType).validate(userQuizScore, { abortEarly: false });
};

export const userMockValidator = (userCourse, requestType:string) => {
  const schema = Joi.object({
    _id:Joi.forbidden(),
    userId: Joi.string().hex().length(24).alter(requiredRule),
    mocks: Joi.array().items(Joi.string().hex().length(24)),
  });
  return schema.tailor(requestType).validate(userCourse, { abortEarly: false });
};

export const questionFlagValidator = (questionFlag, requestType:string) => {
  const schema = Joi.object({
    _id:Joi.forbidden(),
    userId: Joi.string().hex().length(24).alter(requiredRule),
    questionId: Joi.string().hex().length(24).alter(requiredRule),
    comment: Joi.string(),
  });
  return schema.tailor(requestType).validate(questionFlag, { abortEarly: false });
};

export const contentFlagValidator = (contentFlag, requestType:string) => {
  const schema = Joi.object({
    _id:Joi.forbidden(),
    userId: Joi.string().hex().length(24).alter(requiredRule),
    subChapterContentId: Joi.string().hex().length(24).alter(requiredRule),
    comment: Joi.string(),
  });
  return schema.tailor(requestType).validate(contentFlag, { abortEarly: false });
};

export const userQuestionVoteValidator = (questionVote, requestType:string) => {
  const schema = Joi.object({
    _id:Joi.forbidden(),
    userId: Joi.string().hex().length(24).alter(requiredRule),
    questionId: Joi.string().hex().length(24).alter(requiredRule)
  });
  return schema.tailor(requestType).validate(questionVote, { abortEarly: false });
};

export const userContentBookmarkValidator = (contentBookmark, requestType:string) => {
  const schema = Joi.object({
    _id:Joi.forbidden(),
    userId: Joi.string().hex().length(24).alter(requiredRule),
    contentId: Joi.string().hex().length(24).alter(requiredRule)
  });
  return schema.tailor(requestType).validate(contentBookmark, { abortEarly: false });
};

export const telegramUserValidator = (telegramUser, requestType:string) => {
  const schema = Joi.object({
    _id:Joi.forbidden(),
    telegramUserId: Joi.string().alter(requiredRule),
    score: Joi.number().min(0).default(0)
  });
  return schema.tailor(requestType).validate(telegramUser, { abortEarly: false });
};

export const telegramUserQuestionsValidator = (telegramUserQuestion, requestType:string) => {
  const schema = Joi.object({
    _id:Joi.forbidden(),
    questionId: Joi.string().hex().length(24).alter(requiredRule),
    telegramUser: Joi.string().hex().length(24).alter(requiredRule)
  });
  return schema.tailor(requestType).validate(telegramUserQuestion, { abortEarly: false });
};

export const reviwerValidator = (reviwerUser, requestType: string) => {
  const schema= Joi.object({
    _id: Joi.forbidden(),
    userId:  Joi.string().hex().length(24).alter(requiredRule),
    firstName: Joi.string().alter(requiredRule),
    lastName: Joi.string().alter(requiredRule),
    avatar:  Joi.string().hex().length(24),
    subject: Joi.array().items((Joi.string().valid(...Object.values(Subject))))
  })
  return schema.tailor(requestType).validate(reviwerUser, { abortEarly: false });
}

export const adminValidator = (reviwerUser, requestType: string) => {
  const schema= Joi.object({
    _id: Joi.forbidden(),
    userId:  Joi.string().hex().length(24).alter(requiredRule),
    firstName: Joi.string().required().alter(requiredRule),
    lastName: Joi.string().required().alter(requiredRule),
    avatar: Joi.string().hex().length(24).default(null),
  })
  return schema.tailor(requestType).validate(reviwerUser, { abortEarly: false });
}

export const subChapterReviewValidation = (subChapterReview, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    subChapterId: Joi.string().hex().length(24).alter(requiredRule),
    reviewerId: Joi.string().hex().length(24).alter(requiredRule),
    status: Joi.string().valid('approved', 'pending', 'denied'),
    requestedBy: Joi.string().hex().length(24).default(null),
    chapterId: Joi.string().hex().length(24).alter(requiredRule),
    courseId: Joi.string().hex().length(24).alter(requiredRule),
  });

  return schema.tailor(requestType).validate(subChapterReview, { abortEarly: false });
};

export const contentReviewValidation = (contentReview, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    subChapterContentId: Joi.string().hex().length(24).alter(requiredRule),
    status: Joi.string().valid('approved', 'pending', 'declined'),
    reviewerId: Joi.string().hex().length(24).alter(requiredRule),
    comment: Joi.string(),
    requestedBy: Joi.string().hex().length(24).default(null),
  });

  return schema.tailor(requestType).validate(contentReview, { abortEarly: false });
};

export const questionReviewValidation = (questionReview, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    questionId: Joi.string().hex().length(24).alter(requiredRule),
    reviewerId: Joi.string().hex().length(24).alter(requiredRule),
    requestedBy: Joi.string().hex().length(24).alter(requiredRule),
    comment: Joi.string(),
    status: Joi.string().valid('approved', 'pending', 'declined'),
  });

  return schema.tailor(requestType).validate(questionReview, { abortEarly: false });
};

export const mockReviewValidation = (mockReview, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    mockId: Joi.string().hex().length(24).alter(requiredRule),
    reviewerId: Joi.string().hex().length(24).alter(requiredRule),
    status: Joi.string().valid('approved', 'pending', 'declined'),
    requestedBy: Joi.string().hex().length(24).alter(requiredRule),
  });

  return schema.tailor(requestType).validate(mockReview, { abortEarly: false });
};

export const contestValidation = (contest, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    description: Joi.string(),
    departmentId: Joi.string().hex().length(24).alter(requiredRule),
    title: Joi.string(),
    liveRegister: Joi.number(),
    virtualRegister: Joi.number(),
    startsAt: Joi.date().iso().alter(requiredRule),
    endsAt: Joi.date().iso().greater(Joi.ref('startsAt')).alter(requiredRule),
  });

  return schema.tailor(requestType).validate(contest, { abortEarly: false });
};

export const userContestValidation = (userContest, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    contestId: Joi.string().hex().length(24).alter(requiredRule),
    userId: Joi.string().hex().length(24).alter(requiredRule),
    startedAt: Joi.date().iso(),
    finishedAt: Joi.date().iso().greater(Joi.ref('startedAt')),
    score: Joi.number().default(0).default(0),
    type: Joi.string().valid('virtual', 'live').default('virtual'),
  });

  return schema.tailor(requestType).validate(userContest, { abortEarly: false });
};

export const contestCategoryValidation = (contestCategory, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    title: Joi.string().required(),
    subject: Joi.string().valid(...Object.values(Subject)).required(),
    contestId: Joi.string().hex().length(24).alter(requiredRule),
  });

  return schema.tailor(requestType).validate(contestCategory, { abortEarly: false });
};

export const contestQuestionValidation = (contestQuestion: any, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    contestCategoryId: Joi.string().hex().length(24).alter(requiredRule),
    chapterId: Joi.string().alter(requiredRule),
    courseId: Joi.string().alter(requiredRule),
    subChapterId: Joi.string().alter(requiredRule),
    description: Joi.string().alter(requiredRule),
    choiceA: Joi.string().alter(requiredRule),
    choiceB: Joi.string().alter(requiredRule),
    choiceC: Joi.string().alter(requiredRule),
    choiceD: Joi.string().alter(requiredRule),
    answer: Joi.string().alter(requiredRule),
    explanation: Joi.string().alter(requiredRule),
    difficulty: Joi.number().default(5),
    relatedTopic: Joi.string().default('No related topic for now!'),
    questionId: Joi.string().hex().length(24).default(null)
  });

  return schema.tailor(requestType).validate(contestQuestion, { abortEarly: false });
};

export const prizeValidation = (prize: any, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    standing: Joi.number().required(),
    description: Joi.string().required(),
    type: Joi.string().valid(...Object.values(PrizeType)).required(),
    amount: Joi.number().required(),
  });

  return schema.tailor(requestType).validate(prize, { abortEarly: false });
};

export const contestPrizeValidation = (contestPrize: any, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    prizeIds: Joi.array().items(Joi.string().required()).required(),
    contestId: Joi.string().required(),
  });

  return schema.tailor(requestType).validate(contestPrize, { abortEarly: false });
};
export const dailyQuizValidator = (dailyQuiz: any, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    day: Joi.date().iso().alter(requiredRule),
    description: Joi.string().default("Complete daily quiz to earn points!"),
    departmentId: Joi.string().hex().length(24).alter(requiredRule),
    questions: Joi.array().items(Joi.string().hex().length(24)).alter(requiredRule)
  });

  return schema.tailor(requestType).validate(dailyQuiz, { abortEarly: false });
};

export const userDailyQuizValidator = (userDailyQuiz: any, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    dailyQuizId: Joi.string().hex().length(24).alter(requiredRule),
    userId: Joi.string().hex().length(24).alter(requiredRule),
    score: Joi.number().integer().alter(requiredRule)
  });

  return schema.tailor(requestType).validate(userDailyQuiz, { abortEarly: false });
};


export const schoolValidationSchema = Joi.object({
  name: Joi.string().required(),
  region: Joi.string().valid(...Object.values(RegionEnum)).required(),
});

export const videoContentValidator = (videoContent: any, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    courseId: Joi.string().hex().length(24).alter(requiredRule),
    chapterId: Joi.string().hex().length(24).alter(requiredRule),
    subChapterId: Joi.string().hex().length(24).alter(requiredRule),
    title: Joi.string().alter(requiredRule),
    order: Joi.number().default(0),
    duration: Joi.string().default("00:10:00"),
    link: Joi.string().uri().alter(requiredRule),
    thumbnail: Joi.string().uri().alter(requiredRule),
    videoChannelId: Joi.string().hex().length(24).alter(requiredRule),
  });
  return schema.tailor(requestType).validate(videoContent, { abortEarly: false });
};

export const reviewerAdminValidator = (reviwerUser, requestType: string) => {
  const schema= Joi.object({
    _id: Joi.forbidden(),
    userId:  Joi.string().hex().length(24).alter(requiredRule),
    firstName: Joi.string().required().alter(requiredRule),
    lastName: Joi.string().required().alter(requiredRule),
    avatar: Joi.string().hex().length(24).default(null),
  })
  return schema.tailor(requestType).validate(reviwerUser, { abortEarly: false });
}

export const videoChannelValidator = (videoChannel: any, requestType: string) => {
  const schema = Joi.object({
    _id: Joi.forbidden(),
    channelName: Joi.string().alter(requiredRule),
    channelUrl: Joi.string().alter(requiredRule),
    channelType: Joi.string(),
    createdAt: Joi.forbidden(),
    updatedAt: Joi.forbidden()
  });
  return schema.tailor(requestType).validate(videoChannel, { abortEarly: false });
}