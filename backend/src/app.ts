import express, { Application, Request, Response, NextFunction } from "express";

import { BaseResponse } from "./types/baseResponse";
import routes from "./routes";
import errorHandler from "./middlewares/ErrorHandler";
import cookieParser from "cookie-parser";
import expressupload from "express-fileupload";
import cors from "cors";

const app: Application = express();

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(cookieParser());
app.use(expressupload());
app.use(cors());

app.use("/api/v1/user", routes.userRouter);
app.use("/api/v1/department", routes.departmentRouter);
app.use("/api/v1/course", routes.courseRouter);
app.use("/api/v1/chapter", routes.chapterRouter);
app.use("/api/v1/sub-chapter", routes.subChapterRouter)
app.use("/api/v1/userCourse", routes.userCourseRoutes);


app.get("/", (req, res) => {
  let baseResponse = new BaseResponse();
  baseResponse.success = true;
  baseResponse.message =
    "Welcome to Personalized Exam Preparation Companion Page!";
  baseResponse.data = {
    welcome: "Welcome to Personalized Exam Preparation Companion Page!",
  };
  return res.status(200).json({ ...baseResponse });
});

// Error handling
app.use(errorHandler);

export const config = {
  api: {
    timeout: 30,
  },
};

export default app;
