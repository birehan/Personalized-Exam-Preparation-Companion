import { Router } from "express";
import dailyQuizControllers from "../controllers/dailyQuiz";
import isAuthenticated from "../middlewares/authenticate";

const router = Router();
router.get("/getDailyQuiz", isAuthenticated, dailyQuizControllers.getDailyQuiz);
router.get("/getDailyQuizAnalysis/:id", isAuthenticated, dailyQuizControllers.getDailyQuizAnalysis);
router.post("/submitDailyQuizAnswers", isAuthenticated, dailyQuizControllers.submitDailyQuizAnswers);


export default router;