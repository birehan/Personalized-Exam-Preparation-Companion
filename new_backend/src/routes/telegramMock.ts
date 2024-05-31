import { Router } from "express";
import mockControllers from "../controllers/telegramMock";
import isAuthenticated from "../middlewares/authenticate";

const router = Router();
router.get("/", mockControllers.getMocks);
router.post("/", mockControllers.createMock);
router.post("/standardMock", mockControllers.createStandardMock);
router.get("/:id", isAuthenticated, mockControllers.getMock);
router.put("/:id", mockControllers.updateMock);
router.delete("/:id", mockControllers.deleteMock);

export default router;