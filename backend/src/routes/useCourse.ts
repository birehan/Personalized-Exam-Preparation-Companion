import { Router } from "express";
import userCourseController from "../controllers/userCourse";
import isAuthenticated from "../middlewares/authenticate";

const router = Router();
router.get("/", isAuthenticated,userCourseController.getUserCourses);
router.post("/", isAuthenticated, userCourseController.createUserCourse);
router.get("/:id", isAuthenticated, userCourseController.getUserCourse);
router.put("/addCourse",isAuthenticated, userCourseController.addCourseToUserCourses);
router.put("/removeCourse",isAuthenticated, userCourseController.removeCourseFromUserCourses);
router.delete("/:id", isAuthenticated, userCourseController.deleteUserCourse);

export default router;