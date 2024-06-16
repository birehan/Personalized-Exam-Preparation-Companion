import { Router } from "express";
import courseController from "../controllers/course";
import videoContentControllers from "../controllers/videoContent";
import isAuthenticated from "../middlewares/authenticate";
import uploader from "../middlewares/uploader";
import aggregateMiddleware from "../middlewares/courseAggregateMiddleware";

const router = Router();
router.get("/", isAuthenticated, aggregateMiddleware, courseController.getCourses);
router.post("/", uploader, courseController.createCourse);
router.get("/departmentCourses/:departmentId", isAuthenticated, courseController.getCoursesByDepartment);
router.get("/:id", isAuthenticated, courseController.getCourse);
router.put("/:id", uploader, courseController.updateCourse);
router.delete("/:id", courseController.deleteCourse);
router.get("/download/:id",isAuthenticated, courseController.downloadCourse);


//videoContents 
router.get("/video/", isAuthenticated, aggregateMiddleware, videoContentControllers.getVideoContents);
router.post("/video/", videoContentControllers.createVideoContent);
router.put("/video/analysis/:id", isAuthenticated, videoContentControllers.updateUserVideoAnalysis);
router.get("/video/content/:id", isAuthenticated, videoContentControllers.getVideoContentsByCourse);
router.get("/video/content/byChannel/:id", isAuthenticated, videoContentControllers.getByChannelId);
router.get("/video/:id", isAuthenticated, videoContentControllers.getVideoContent);
router.put("/video/:id", videoContentControllers.updateVideoContent);
router.delete("/video/:id", videoContentControllers.deleteVideoContent);


export default router;