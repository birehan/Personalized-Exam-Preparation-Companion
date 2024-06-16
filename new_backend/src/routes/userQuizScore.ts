import { Router } from "express";
import createUserQuizScore from "../controllers/userQuizScore";
import isAuthenticated from "../middlewares/authenticate";

const router = Router();
// router.get("/", isAuthenticated, quizControllers.getUserQuizzes);
router.post("/",isAuthenticated, createUserQuizScore);

export default router;