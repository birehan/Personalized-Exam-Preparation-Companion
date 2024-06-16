import { Router } from "express";
import questionControllers from "../controllers/question";
import isAuthenticated from "../middlewares/authenticate";

const router = Router();
router.get("/", questionControllers.getQuestions);
router.post("/", questionControllers.createQuestion);
router.get("/:id", questionControllers.getQuestion);
router.put("/:id", questionControllers.updateQuestion);
router.delete("/:id", questionControllers.deleteQuestion);

export default router;