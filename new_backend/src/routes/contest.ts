import { Router } from "express";
import contestController from "../controllers/contest";
import userContestController from "../controllers/userContest";
import contestCategoryController from "../controllers/contestCategory";
import contestQuestionController from "../controllers/contestQuestion";
import prizeController from "../controllers/prize";
import contestPrizeController from "../controllers/contestPrize";
import isAuthenticated from "../middlewares/authenticate";
import createContestQuestions from "../controllers/contestCreater";

const router = Router();

router.get('/contestCoin/:id', contestController.populateContestCoin)

router.post("/contestCreator", createContestQuestions);//should be protected with PW middleware

router.get("/", contestController.getContests);
router.get("/previousContests", isAuthenticated, contestController.getPreviousContests);
router.post("/", contestController.createContest);
router.get("/contestDetail/:id", isAuthenticated, contestController.getContestDetails);
router.get("/contestRank/:id", isAuthenticated, contestController.getContestRanking);
router.get("/:id", contestController.getContest);
router.put("/:id", contestController.updateContest);
router.delete("/:id", contestController.deleteContest);


//userContest related
router.get("/userContest", userContestController.getUserContests);
router.post("/userContest", isAuthenticated, userContestController.createUserContest);
router.get("/userContest/upcomingContest", isAuthenticated, userContestController.getNextUpcomingContest);
router.get("/userContest/userPreviousContests", isAuthenticated, userContestController.getUserPreviousContests);
router.get("/userContest/:id", userContestController.getUserContest);
router.put("/userContest/:id", userContestController.updateUserContest);
router.delete("/userContest/:id", userContestController.deleteUserContest);

//ContestCategory related
router.get("/contestCategory", contestCategoryController.getContestCategories);
router.post("/contestCategory", contestCategoryController.createContestCategory);
router.get("/contestCategory/categoryQuestions/:id", isAuthenticated, contestCategoryController.getContestCategoryQuestions);
router.get("/contestCategory/categoryAnalysis/:id", isAuthenticated, contestCategoryController.getContestCategoryAnalysis);
router.get("/contestCategory/:id", contestCategoryController.getContestCategory);
router.post("/contestCategory/submitAnswer", isAuthenticated, contestCategoryController.userCategorySubmitQuestions);
router.put("/contestCategory/:id", contestCategoryController.updateContestCategory);
router.delete("/contestCategory/:id", contestCategoryController.deleteContestCategory);

//Contest question related
router.get("/contestQuestion", contestQuestionController.getContestQuestions);
router.post("/contestQuestion", contestQuestionController.createContestQuestion);
router.get("/contestQuestion/:id", contestQuestionController.getContestQuestion);
router.put("/contestQuestion/:id", contestQuestionController.updateContestQuestion);
router.delete("/contestQuestion/:id", contestQuestionController.deleteContestQuestion);


//Prize related
router.get("/prize", prizeController.getPrize);
router.post("/prize", prizeController.createPrize);
router.get("/prize/:id", prizeController.getPrize);
router.put("/prize/:id", prizeController.updatePrize);
router.delete("/prize/:id", prizeController.deletePrize);

router.get("/contestPrize", contestPrizeController.getContestPrizes);
router.post("/contestPrize", contestPrizeController.createContestPrize);
router.get("/contestPrize/:id", contestPrizeController.getContestPrize);
router.put("/contestPrize/:id", contestPrizeController.updateContestPrize);
router.delete("/contestPrize/:id", contestPrizeController.deleteContestPrize);


export default router;