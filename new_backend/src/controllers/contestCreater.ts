import { Request, Response, NextFunction } from 'express';
import Contest from '../models/contest';
import ContestCategory from '../models/contestCategory';
import ContestQuestion from '../models/contestQuestion';
import Question from '../models/question';
import { BaseResponse } from '../types/baseResponse';

const createContestQuestions = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { contestId, ContestCategories } = req.body;

    // Check if contest with provided contestId exists
    const foundContest = await Contest.findById(contestId);
    if (!foundContest) {
      throw new Error('Contest not found.');
    }

    const createdQuestions = [];

    // Iterate through ContestCategories
    for (const category of ContestCategories) {
      const { subject, title, questions } = category;

      // Create a contestCategory entry
      const createdCategory = await ContestCategory.create({
        contestId,
        subject,
        title,
      });

      // Iterate through questions and create contestQuestion objects
      for (const questionId of questions) {
        const foundQuestion = await Question.findById(questionId);
        if (foundQuestion) {
          const createdContestQuestion = await ContestQuestion.create({
            contestCategoryId: createdCategory._id,
            courseId: foundQuestion.courseId,
            description: foundQuestion.description,
            choiceA: foundQuestion.choiceA,
            choiceB: foundQuestion.choiceB,
            choiceC: foundQuestion.choiceC,
            choiceD: foundQuestion.choiceD,
            answer: foundQuestion.answer,
            relatedTopic: foundQuestion.relatedTopic,
            explanation: foundQuestion.explanation,
            chapterId: foundQuestion.chapterId,
            subChapterId: foundQuestion.subChapterId,
          });

          createdQuestions.push(createdContestQuestion);
        }
      }
    }

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Contest questions created successfully!';
    baseResponse.data = {
      createdQuestions,
    };

    return res.status(201).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

export default createContestQuestions;
