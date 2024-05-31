import { Router } from "express";
import userMockController from "../controllers/userMock";
import isAuthenticated from "../middlewares/authenticate";

const router = Router();
router.get("/", isAuthenticated,userMockController.getUserMocks);
router.put("/addMock",isAuthenticated, userMockController.addMockToUserMocks);
router.put("/removeMock",isAuthenticated, userMockController.removeMockFromUserMocks);
router.put("/retakeMock/:id",isAuthenticated, userMockController.retakeMock);

export default router;