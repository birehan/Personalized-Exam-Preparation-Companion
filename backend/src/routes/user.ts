import { Router } from "express";
import UserControllers from "../controllers/user";
import isAuthenticated from "../middlewares/authenticate";
import uploader from "../middlewares/uploader";

const router = Router();

router.post("/sendOTPCode", UserControllers.sendOtpVerification);
router.post("/reSendOTPCode", UserControllers.resendOtpVerification);
router.post( "/sendOTPCodeForgotPass", UserControllers.forgotPassSendOtpVerification);

router.post("/signup", UserControllers.userSignup);
router.post("/login", UserControllers.userLogin);
router.get("/logout", isAuthenticated, UserControllers.logoutUser);

router.put( "/userChangePassword", isAuthenticated, UserControllers.changePassword);
router.put("/forgotPassVerifyOTP", UserControllers.userForgotPassVerifyOTP);
router.put("/forgotChangePassword", UserControllers.forgotChangePassword);
router.put( "/updateProfile", isAuthenticated, uploader, UserControllers.updateProfile);

router.get("/currentUser", isAuthenticated, UserControllers.currentUser);
router.get("/home", isAuthenticated, UserControllers.userHomePage);

export default router;
