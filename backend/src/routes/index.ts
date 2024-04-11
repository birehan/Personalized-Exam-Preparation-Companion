// package all routes in a single file
import departmentRouter from "./department";
import userRouter from "./user";
import courseRouter from "./course"
import chapterRouter from "./chapter"
import subChapterRouter from "./sub-chapter"
import userCourseRoutes from "./useCourse"


export default {
  userRouter,
  departmentRouter,
  courseRouter,
  chapterRouter,
  subChapterRouter,
  userCourseRoutes
};
