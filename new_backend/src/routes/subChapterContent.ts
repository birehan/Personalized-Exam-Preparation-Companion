import { Router } from "express";
import subChapterContentController from "../controllers/subChapterContent";
import isAuthenticated from "../middlewares/authenticate";

const router = Router();
router.get("/", subChapterContentController.getSubChapterContents);
router.post("/", subChapterContentController.createSubChapterContent);
router.get("/:id", subChapterContentController.getSubChapterContent);
router.put("/:id", subChapterContentController.updateSubChapterContent);
router.delete("/:id", subChapterContentController.deleteSubChapterContent);

export default router;