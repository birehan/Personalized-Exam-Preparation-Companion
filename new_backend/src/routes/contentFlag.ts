import { Router } from "express";
import contentFlagController from "../controllers/contentFlag";
import isAuthenticated from "../middlewares/authenticate";

const router = Router();
router.get("/", contentFlagController.getContentFlags);
router.post("/",isAuthenticated, contentFlagController.createUserContentFlag);

export default router;