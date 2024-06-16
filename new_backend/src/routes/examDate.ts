import { Router } from "express";
import examDateControllers from "../controllers/examDate";
import isAuthenticated from "../middlewares/authenticate";

const router = Router();
router.get("/", examDateControllers.getExamDates);
router.post("/", examDateControllers.createExamDate);
router.get("/:id", examDateControllers.getExamDate);
router.put("/:id", examDateControllers.updateExamDate);
router.delete("/:id", examDateControllers.deleteExamDate);

export default router;