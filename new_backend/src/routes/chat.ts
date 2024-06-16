import { Router } from "express";
import chatControllers from "../controllers/chat";
import isAuthenticated from "../middlewares/authenticate";

const router = Router();
router.post("/onQuestion", isAuthenticated, chatControllers.userChatQuestion);
router.post("/onContent", isAuthenticated, chatControllers.userChatContent);
router.post("/Assistant", isAuthenticated, chatControllers.userGeneralChat);


export default router;