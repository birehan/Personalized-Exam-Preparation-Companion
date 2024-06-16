import { Router } from "express";
import quizControllers from "../controllers/quiz"; 
import isAuthenticated from "../middlewares/authenticate";
import isQuizOwner from "../middlewares/authorization/quiz";

const router = Router();
router.get("/userQuiz/:id", isAuthenticated, quizControllers.getUserQuizzes);
router.post("/",isAuthenticated, quizControllers.createQuiz);
router.get("/:id", isAuthenticated, quizControllers.getUserQuiz);
router.put("/:id", isAuthenticated, isQuizOwner, quizControllers.updateQuiz);
router.delete("/:id", isAuthenticated, isQuizOwner, quizControllers.deleteQuiz);

export default router;