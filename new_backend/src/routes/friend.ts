import { Router } from "express";
import friendsController  from "../controllers/friend";
import isAuthenticated from "../middlewares/authenticate";

const router = Router();
router.get("/", isAuthenticated, friendsController.getFriends);
router.get("/rank", isAuthenticated, friendsController.getFriendsWithRank);
router.post("/sendRequest", isAuthenticated, friendsController.sendFriendRequest);
router.get('/invites', isAuthenticated, friendsController.getPendingFriendRequests)
router.put("/accept/:id", isAuthenticated, friendsController.acceptFriendRequest);
router.put("/reject/:id", isAuthenticated, friendsController.rejectFriendRequest);
router.delete("/unfriend/:id", isAuthenticated, friendsController.unfriendUser);
router.delete("/cancel/:id", isAuthenticated, friendsController.cancelFriendRequest);
router.get("/inviteSent", isAuthenticated, friendsController.getSentPendingRequests);
router.get("/search", isAuthenticated, friendsController.searchUser);


export default router;