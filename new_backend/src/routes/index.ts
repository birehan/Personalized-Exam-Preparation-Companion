// package all routes in a single file

import userRouter from "./user";
import questionRouter from "./question"
import quizRouter from "./quiz"
import departmentRouter from "./department"
import courseRouter from "./course"
import questionUserAnswerRoute from "./questionUserAnswer"
import chapterRouter from "./chapter"
import subChapterRouter from "./sub-chapter"
import mockRouter from "./mock"
import subChapterContentRouter from "./subChapterContent"
import userChapterAnalysisRoutes from "./userChapterAnalysis"
import generalDepartmentRouter from "./generalDepartment"
import examDateRouter from "./examDate"
import userCourseRoutes from "./userCourse"
import userQuizScore from "./userQuizScore"
import userMockScore from "./userMockScore"
import userMock from "./userMock"
import chatRouter from "./chat"
import questionFlagRouter from "./questionFlag"
import contentFlagRouter from "./contentFlag"
import userQuestionVoteRouter from "./userQuestionVote"
import userContentBookmark from "./userContentBookmark"
import telegramBotRouter from "./telegramBot"
import telegramMockRouter from "./telegramMock"
import contestRouter from "./contest"
import dailyQuizRouter from "./dailyQuiz"
import schoolRouter from "./school"
import dailyQuestRouter from "./dailyQuest"
// import notificationRouter from "./notification"
import friendRouter from './friend'
import videoChannelRouter from "./videoChannels"

export default {
  userRouter,
  questionRouter,
  quizRouter,
  departmentRouter,
  courseRouter,
  questionUserAnswerRoute,
  chapterRouter,
  subChapterRouter,
  mockRouter,
  subChapterContentRouter,
  userChapterAnalysisRoutes,
  generalDepartmentRouter,
  examDateRouter,
  userCourseRoutes,
  userQuizScore,
  userMockScore,
  userMock,
  chatRouter,
  questionFlagRouter,
  contentFlagRouter,
  userQuestionVoteRouter,
  userContentBookmark,
  telegramBotRouter,
  telegramMockRouter,
  contestRouter,
  dailyQuizRouter,
  schoolRouter,
  dailyQuestRouter,
  // notificationRouter,
  friendRouter,
  videoChannelRouter
};
