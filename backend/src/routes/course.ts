import { Router } from "express";
import courseController from "../controllers/course";
import isAuthenticated from "../middlewares/authenticate";
import uploader from "../middlewares/uploader";

const router = Router();
router.get("/", isAuthenticated, courseController.getCourses);
router.post("/", uploader, courseController.createCourse);
router.get("/departmentCourses/:departmentId", isAuthenticated, courseController.getCoursesByDepartment);
router.get("/:id", isAuthenticated, courseController.getCourse);
router.put("/:id", uploader, courseController.updateCourse);
router.delete("/:id", courseController.deleteCourse);


export default router;