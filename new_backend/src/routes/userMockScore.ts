import { Router } from "express";
import isAuthenticated from "../middlewares/authenticate";
import userMockScoreController from "../controllers/userMockScore";

const router = Router();
// router.get("/", isAuthenticated, quizControllers.getUserQuizzes);
router.post("/",isAuthenticated, userMockScoreController.createUserMockScore);
router.get("/getMockRank/:mockId",isAuthenticated, userMockScoreController.userMockRank);
export default router;