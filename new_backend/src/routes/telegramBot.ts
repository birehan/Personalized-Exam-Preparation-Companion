import { Router } from "express";
import telegramBotControllers from "../controllers/telegramBot";

const router = Router();

router.get("/", telegramBotControllers.getCoursesBySubject);
router.get("/leaderBoard", telegramBotControllers.getTopTelegramUsers);
router.get("/nationalMocks", telegramBotControllers.getStandardMocksBySubject);
router.get("/courseChapters/:id", telegramBotControllers.getCourseChapters);
router.get("/chapterSubChapters/:id", telegramBotControllers.getChapterSubChapters);
router.get("/subChapterContents/:id", telegramBotControllers.getSubChapterContents);
router.get("/getUserScore/:id", telegramBotControllers.getUserScore);
router.get("/getMockQuestion/:id", telegramBotControllers.getStandardMockQuestion);

router.post("/createQuiz", telegramBotControllers.getQuiz);
router.post("/addScore", telegramBotControllers.addScore);

export default router;