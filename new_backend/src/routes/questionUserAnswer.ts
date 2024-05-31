import { Router } from "express";
import questionUserAnswerControllers from "../controllers/questionUserAnswer";
import isAuthenticated from "../middlewares/authenticate";
import isQuestionUserAnswerOwner from "../middlewares/authorization/questionUserAnswer"

const router = Router();
router.get("/", questionUserAnswerControllers.getQuestionsUserAnswers);
router.post("/", isAuthenticated, questionUserAnswerControllers.createQuestionUserAnswer);
router.post("/upsertUserAnswer", isAuthenticated, questionUserAnswerControllers.upsertQuestionUserAnswer);
router.post("/upsertUserAnswers", isAuthenticated, questionUserAnswerControllers.upsertQuestionUserAnswers);
router.get("/:id", questionUserAnswerControllers.getQuestionUserAnswer);
router.put("/:id", isAuthenticated, isQuestionUserAnswerOwner, questionUserAnswerControllers.updateQuestionUserAnswer);
router.delete("/:id",isAuthenticated, isQuestionUserAnswerOwner, questionUserAnswerControllers.deleteQuestionUserAnswer);

export default router;