import { Router } from "express";
import userQuestionVoteController from "../controllers/userQuestionVote";
import isAuthenticated from "../middlewares/authenticate";

const router = Router();
router.post("/", isAuthenticated, userQuestionVoteController.createUserQuestionVote);
router.post("/:id",isAuthenticated, userQuestionVoteController.deleteUserQuestionVote);

export default router;