import { Request, Response, NextFunction } from 'express';
import UserQuizScore from '../models/userQuizScore';
import Quiz from '../models/quiz';
import { userQuizScoreValidator } from '../validations/joiModelValidator';
import { logUserDailyActivity, normalizeScore, updateUserPoint } from '../services/helpers';
import { UserScoreTracker } from '../types/typeEnum';

const createUserQuizScore = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const userId = req.body.user._id.toString();

    const { quizId, score } = req.body;

    const userInput = { userId, quizId, score };

    const { error, value } = userQuizScoreValidator(userInput, 'post');

    if (error) throw error;

    const foundQuiz = await Quiz.findOne({ _id: quizId });

    if (!foundQuiz) {
      throw new Error('No quiz found with that ID');
    }

    if (foundQuiz.userId.toString() !== userId) throw Error("This quiz doesn't belong to this user");

    if (score > foundQuiz.questions.length) {
        throw new Error('Score cannot be greater than the number of questions in the quiz');
    }

    const foundUserQuizScore = await UserQuizScore.findOne({ userId, quizId }).lean().exec()

    const prevScore = foundUserQuizScore ? foundUserQuizScore.score as number : 0;

    const filter = { userId, quizId };
    const update = { $set: { score }, $setOnInsert: { createdAt: new Date() } };
    const options = { upsert: true, new: true, setDefaultsOnInsert: true };

    const savedUserQuizScore = await UserQuizScore.findOneAndUpdate(filter, update, options);
    const dailyActivitySuccess= await logUserDailyActivity(userId, new Date(), 'quiz')

    const userScoreUpdate = new UserScoreTracker()
    userScoreUpdate.previousScore = normalizeScore(prevScore, 3, foundQuiz.questions.length)
    userScoreUpdate.currentScore = normalizeScore(score, 3, foundQuiz.questions.length)

    await updateUserPoint(userId, userScoreUpdate);

    const baseResponse = {
      success: true,
      message: 'User Quiz Score created/updated successfully!',
      data: {
        newUserQuizScore: savedUserQuizScore,
      },
    };

    return res.status(201).json(baseResponse);
  } catch (error) {
    next(error);
  }
};

export default createUserQuizScore;