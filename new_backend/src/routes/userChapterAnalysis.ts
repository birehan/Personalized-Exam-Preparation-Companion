import { Router } from "express";
import userChapterAnalysisControllers from "../controllers/userChapterAnalysis";
import isAuthenticated from "../middlewares/authenticate";

const router = Router();
router.post("/addSubChapter", isAuthenticated, userChapterAnalysisControllers.addSubchapter);
router.put("/removeSubChapter", isAuthenticated, userChapterAnalysisControllers.removeSubChapter);
router.post('/userVideo', isAuthenticated, userChapterAnalysisControllers.updateUserVideoAnalysis);

export default router;