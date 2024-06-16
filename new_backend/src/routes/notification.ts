import { Router } from "express";
import notificationControllers from "../controllers/notification";
import isAuthenticated from "../middlewares/authenticate";

const router = Router();

router.post("/sendNotification", notificationControllers.sendNotification);
router.post("/sendSMSToAll", notificationControllers.sendMessageToAllUsers);


export default router;