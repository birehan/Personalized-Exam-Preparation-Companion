import express, {
  Application,
  Request,
  Response,
  NextFunction
} from 'express'

import { BaseResponse } from './types/baseResponse';
import routes from "./routes";
import dashboardRoutes from "./dashboard/routers";
import errorHandler from "./middlewares/ErrorHandler";
import cookieParser from "cookie-parser";
import expressupload from "express-fileupload";
import cors from "cors";
import { rateLimiterMiddleware } from './middlewares/rateLimiter';
import helmet from 'helmet';
import bodyParser from 'body-parser';

const app: Application = express()

app.use(helmet());
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(cookieParser());
app.use(expressupload());
app.use(cors());

app.use(rateLimiterMiddleware);
app.use(bodyParser.json({ limit: '1mb' })); //request size limit set to 1 MB

app.use("/api/v1/user", routes.userRouter);
app.use("/api/v1/question", routes.questionRouter);

app.use("/api/v1/quiz", routes.quizRouter);
app.use("/api/v1/mock", routes.mockRouter);


app.use("/api/v1/questionUserAnswer", routes.questionUserAnswerRoute);

app.use("/api/v1/chapter", routes.chapterRouter);
app.use("/api/v1/sub-chapter", routes.subChapterRouter)

app.use("/api/v1/department", routes.departmentRouter);
app.use("/api/v1/generalDepartment", routes.generalDepartmentRouter);
app.use("/api/v1/examDate", routes.examDateRouter);

app.use("/api/v1/course", routes.courseRouter);
app.use("/api/v1/subChapterContent", routes.subChapterContentRouter);

app.use("/api/v1/userChapterAnalysis", routes.userChapterAnalysisRoutes);
app.use("/api/v1/userCourse", routes.userCourseRoutes);
app.use("/api/v1/userMock", routes.userMock);
app.use("/api/v1/generalDepartment", routes.generalDepartmentRouter);

app.use("/api/v1/userQuizScore", routes.userQuizScore);
app.use("/api/v1/userMockScore", routes.userMockScore);

app.use("/api/v1/chat", routes.chatRouter);

app.use("/api/v1/questionFlag", routes.questionFlagRouter);
app.use("/api/v1/contentFlag", routes.contentFlagRouter);

app.use("/api/v1/userQuestionVote", routes.userQuestionVoteRouter);
app.use("/api/v1/userContentBookmark", routes.userContentBookmark);
app.use("/api/v1/contest", routes.contestRouter);
app.use("/api/v1/dailyQuiz", routes.dailyQuizRouter);
app.use("/api/v1/school", routes.schoolRouter);
app.use("/api/v1/dailyQuest", routes.dailyQuestRouter);

app.use("/api/v1/telegramBot", routes.telegramBotRouter);
app.use("/api/v1/telegramMock", routes.telegramMockRouter);

app.use("/api/v1/dashboard", dashboardRoutes.allRoutes);

// app.use("/api/v1/notification", routes.notificationRouter);
app.use("/api/v1/friend", routes.friendRouter);

app.use("/api/v1/videoChannels", routes.videoChannelRouter);

app.get("/", (req, res) => {
  let baseResponse = new BaseResponse();
  baseResponse.success = true
  baseResponse.message = "Welcome to Skill Bridge Page!"
  baseResponse.data = {
    welcome: "Welcome to Skill Bridge Page!"
  }
  return res.status(200).json({ ...baseResponse });
});

// Error handling 
app.use(errorHandler);

export const config = {
  api: {
    timeout: 30
  }
};

export default app;

