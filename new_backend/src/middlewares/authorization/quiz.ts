import { Request, Response, NextFunction } from 'express'
import Quiz from '../../models/quiz';

export default async function isQuizOwner(req: Request, res: Response, next: NextFunction) {
	try {
		const { user } : { user } = req.body
		const { id : quizId } = req.params

		const foundQuiz = await Quiz.findById(quizId)
		if (!foundQuiz) {
			return res.status(404).json({ message: 'Quiz not found' })
		}
		if ((foundQuiz.userId.toString() !== user._id.toString())) {
			next(new Error("User not authorised"))
		} else {
			if (foundQuiz.userId.toString() === user._id.toString()) {
				next()
			} else {
				return res.status(403).json({ message: 'user not authorized' })
			}
		}
	} catch (error) {
		next(error)
	}
}