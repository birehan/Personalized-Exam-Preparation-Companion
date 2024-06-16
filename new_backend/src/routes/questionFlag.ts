import { Router } from "express";
import questionFlagController from "../controllers/questionFlag";
import isAuthenticated from "../middlewares/authenticate";

const router = Router();
router.get("/", questionFlagController.getQuestionFlags);
router.post("/",isAuthenticated, questionFlagController.createUserQuestionFlag);

export default router;