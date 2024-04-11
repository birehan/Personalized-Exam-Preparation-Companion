import { Router } from "express";
import chapterControllers from "../controllers/chapter";
import isAuthenticated from "../middlewares/authenticate";

const router = Router();
router.get("/courseChapters/:courseId", chapterControllers.getChaptersOfCourse);
router.get("/", chapterControllers.getChapters);
router.get("/:id", chapterControllers.getChapter);

router.post("/", chapterControllers.createChapter);
router.put("/:id", chapterControllers.updateChapter);
router.delete("/:id", chapterControllers.deleteChapter);

export default router;