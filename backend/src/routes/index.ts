// package all routes in a single file
import departmentRouter from "./department";
import userRouter from "./user";
import courseRouter from "./course"


export default {
  userRouter,
  departmentRouter,
  courseRouter,
};
