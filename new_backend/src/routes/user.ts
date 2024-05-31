import { Router } from "express";
import UserControllers from "../controllers/user";
import userBookmarksController from "../controllers/userBookmarks";
import isAuthenticated from "../middlewares/authenticate";
import uploader from "../middlewares/uploader";
import leaderboardController from "../controllers/userLeaderBoard";
import userStreakController from "../controllers/daynamicContent";
import userAuthControllers from "../controllers/auth";

const router = Router();

router.post("/sendOTPCode", UserControllers.sendOtpVerification);
router.post("/reSendOTPCode", UserControllers.resendOtpVerification);
router.post("/sendOTPCodeForgotPass", UserControllers.forgotPassSendOtpVerification);

router.post("/signup", UserControllers.userSignup);
router.post("/login", UserControllers.userLogin);
router.get("/logout", isAuthenticated, UserControllers.logoutUser);
router.post("/googleSingIn", userAuthControllers.userAuthWithToken);

router.post("/userChangePassword", isAuthenticated, UserControllers.changePassword);
router.post("/forgotPassVerifyOTP", UserControllers.userForgotPassVerifyOTP);
router.post("/forgotChangePassword", UserControllers.forgotChangePassword);
router.put("/updateProfile", isAuthenticated, uploader, UserControllers.updateProfile);
router.get("/userScoreCategory", isAuthenticated, UserControllers.getUserScoreCategory);


router.get("/currentUser", isAuthenticated, UserControllers.currentUser);
router.get("/userConsistencydata", isAuthenticated, UserControllers.getUserConsistencyData);
router.get("/home", isAuthenticated, UserControllers.userHomePage);
router.get("/userStreak", isAuthenticated, userStreakController.getUserStreak);
router.get("/bookmarks", isAuthenticated, userBookmarksController.getUserBookmarks);
router.get("/leaderboard", isAuthenticated, leaderboardController.getLeaderboard);
router.get("/weeklylLeaderboard", isAuthenticated, leaderboardController.getWeeklyLeaderboard);
router.get("/monthlyLeaderboard", isAuthenticated, leaderboardController.getMonthlyLeaderboard);
router.get('/leaderboard/getUser/:userId', isAuthenticated, UserControllers.getUserData)
router.get('/leaderboard/getUserStreak/:userId', isAuthenticated, UserControllers.getUserConsistencyDataById);
router.get('/getUserCoin', isAuthenticated, UserControllers.getUserCoin);

export default router;