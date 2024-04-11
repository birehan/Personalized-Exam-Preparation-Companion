import { Router } from "express";
import subChapterControllers from "../controllers/subChapter";
import isAuthenticated from "../middlewares/authenticate";

const router = Router();
router.get("/content/:id", isAuthenticated, subChapterControllers.getSubChapter);
router.get("/:chapterId", isAuthenticated, subChapterControllers.getSubChapters);
router.post("/", subChapterControllers.createSubChapter);
router.put("/:id", subChapterControllers.updateSubChapter);
router.delete("/:id", subChapterControllers.deleteSubChapter);

export default router;