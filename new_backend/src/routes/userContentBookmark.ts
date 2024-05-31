import { Router } from "express";
import userContentBookmarkController from "../controllers/userContentBookmark";
import isAuthenticated from "../middlewares/authenticate";

const router = Router();
router.post("/", isAuthenticated, userContentBookmarkController.createUserContentBookmark);
router.post("/:id",isAuthenticated, userContentBookmarkController.deleteUserContentBookmark);

export default router;