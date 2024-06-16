import { Router } from "express";
import dailyQuestControllers from "../controllers/dailyQuest";
import isAuthenticated from "../middlewares/authenticate";

const router = Router();
router.get("/getDailyQuest", isAuthenticated, dailyQuestControllers.getDailyQuest);

//TODO: add other routes to create and update daily quest

export default router;