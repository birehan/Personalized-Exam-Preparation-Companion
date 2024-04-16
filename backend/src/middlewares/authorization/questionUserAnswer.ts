import { Request, Response, NextFunction } from 'express'
import QuestionUserAnswer from '../../models/questionUserAnswer';

export default async function isQuestionUserAnswerOwner(req: Request, res: Response, next: NextFunction) {
	try {
		const { user } : { user } = req.body
		const { id : questionUserAnswerId } = req.params

		const questionUserAnswer = await QuestionUserAnswer.findById(questionUserAnswerId)
		if (!questionUserAnswer) {
			return res.status(404).json({ message: 'Question user answer not found' })
		}

		const questionUser = await QuestionUserAnswer.findOne({ _id: questionUserAnswer })
		if (!questionUser) {
			return res.status(404).json({ message: 'user not found' })
		}
		if ((questionUser.userId.toString() !== user._id.toString())) {
			next(new Error("User not authorised"))
		} else {
			if (questionUser.userId.toString() === user._id.toString()) {
				next()
			} else {
				return res.status(403).json({ message: 'user not authorized' })
			}
		}
	} catch (error) {
		next(error)
	}
}