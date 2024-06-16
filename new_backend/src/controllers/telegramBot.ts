import { Request, Response, NextFunction } from 'express';
import Course from '../models/course';
import { BaseResponse } from '../types/baseResponse';
import Chapter from '../models/chapter';
import SubChapter from '../models/subChapter';
import SubChapterContent from '../models/subChapterContent';
import { quizValidator, telegramUserQuestionsValidator, telegramUserValidator } from '../validations/joiModelValidator';
import Question from '../models/question';
import { shuffleArray } from '../services/helpers';
import TelegramUser from '../models/telegramUser';
import TelegramUserQuestion from '../models/telegramUserQuestoins';
import Mock from '../models/mock';
import TelegramMock from '../models/telegramMock';
import TelegramQuestion from '../models/telegramQuestions';

const getCoursesBySubject = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const subject = req.query.subject?.toString();

        const courses = await Course.find({
            name: { $regex: new RegExp(subject, 'i') },
        }).select('_id name grade').sort({ grade: 1 }).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Courses retrieved successfully!'
        baseResponse.data = {
           courses: courses,
        }

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error);
    }
};

const getCourseChapters = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const id = req.params.id;
        const course = await Course.findOne({_id:id}).select("_id name description grade").lean().exec();

        if (!course) throw Error("Course not found with that Id.")
        
        const chapters = await Chapter.find({ courseId: id }).lean().select("_id name").sort({ order: 1 }).exec();
        
        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Course chapters retrieved successfully!'
        baseResponse.data = {
           course,
           chapters,
        }

        return res.status(200).json({...baseResponse});

    } catch (error) {
        next(error)
    }
}

const getChapterSubChapters = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const id = req.params.id;
        const chapter = await Chapter.findOne({_id:id}).select("_id name description").lean().exec();

        if (!chapter) throw Error("Chapter not found with that Id.")
        
        const subChapters = await SubChapter.find({chapterId: id}).lean().select("_id name").exec()
        
        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Chapter topics chapters retrieved successfully!'
        baseResponse.data = {
           chapter,
           subChapters,
        }

        return res.status(200).json({...baseResponse});

    } catch (error) {
        next(error)
    }
}

const getSubChapterContents = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const id = req.params.id;
        const subChapter = await SubChapter.findOne({_id:id}).select("_id name").lean().exec();

        if (!subChapter) throw Error("Sub-Chapter not found with that Id.")
        
        const contents = await SubChapterContent.find({subChapterId: id}).lean().exec();
        
        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'sub chapter contents retrieved successfully!'
        baseResponse.data = {
            subChapter,
           contents,
        }

        return res.status(200).json({...baseResponse});

    } catch (error) {
        next(error)
    }
}

const getQuiz = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { numOfQuestion, chapters } = req.body;
  
      const userInput = { name:"Quiz Name", numOfQuestion, chapters, courseId:"64943e13f296abbe4531d066", userId:"64943e13f296abbe4531d066" };
  
      const { error, value } = quizValidator(userInput, "post");
  
      if (error) throw error;

      if (numOfQuestion > 20 ) throw Error("Can't create a quiz with more than 20 questions.")
  
      if (chapters.length > 10) throw Error("Number of chapters should be less than 10.");
  
      //The following logic will be update after discussion with telegram-bot team-> should quizzes be created for just one course chapters or across courses?
      const validChapters = await Chapter.find({ _id: { $in: chapters } }).lean().exec();
  
      if (validChapters.length !== chapters.length) {
        throw Error("One or more chapters sent do not exist!");
      }
  
      const questionsPromises = validChapters.map(async (chapter) => {
        return TelegramQuestion.find({ chapterId: chapter._id, isForQuiz: true, isForMock:false }).lean().exec();
      });
  
      const chapterQuestionsArray = await Promise.all(questionsPromises);
      const allQuestions = chapterQuestionsArray.flat();
  
      if (!allQuestions || allQuestions.length === 0) {
        throw Error("No questions found for the chapters provided!");
      }

      const shuffledQuestions = shuffleArray(allQuestions);
      const selectedQuestions = shuffledQuestions.slice(0, numOfQuestion);
  
      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = "Quiz created successfully!";
      baseResponse.data = {
        newQuiz: selectedQuestions,
      };
  
      return res.status(201).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };

//The following block adds a question user solved and increases user score by one
const addScore = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { questionId, telegramUserId } = req.body;

        const foundQuestion = await TelegramQuestion.findOne({_id: questionId}).lean().exec();

        if (!foundQuestion) {throw Error("No question found with that ID!")}

        let foundTelegramUser = await TelegramUser.findOne({telegramUserId,}).lean().exec();

        if (!foundTelegramUser) {
            const { error, value } = telegramUserValidator({telegramUserId, score: 0}, "post");

            if (error) throw error

            const newUser = new TelegramUser({...value});
            foundTelegramUser = await newUser.save();
        }

        const foundUserQuestion = await TelegramUserQuestion.findOne({telegramUser: foundTelegramUser._id.toString(), questionId: questionId});

        if (!foundUserQuestion) {
            const { error, value } = telegramUserQuestionsValidator({telegramUser: foundTelegramUser._id.toString(), questionId: questionId}, "post");

            if (error) throw error

            const newQuestionSolved = new TelegramUserQuestion({...value});
            const savedUserQuestion = await newQuestionSolved.save();
            
            const updateUserScore = await TelegramUser.findByIdAndUpdate(foundTelegramUser._id.toString(), {score:Number(foundTelegramUser.score) + 1}).lean().exec();
        }
        
        const newScore = await TelegramUser.findOne({telegramUserId,}).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Score added successfully!'
        baseResponse.data = {
            newScore,
        }

        return res.status(200).json({...baseResponse});

    } catch (error) {
        next(error)
    }
}

const getUserScore = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const telegramUserId = req.params.id;
        
        let userScore = await TelegramUser.findOne({telegramUserId,}).lean().exec();

        if (!userScore){
            const { error, value } = telegramUserValidator({telegramUserId, score: 0}, "post");

            if (error) throw error

            const newUser = new TelegramUser({...value});
            await newUser.save();

            userScore = await TelegramUser.findOne({telegramUserId,}).lean().exec();
        }

        const userRank = await TelegramUser.countDocuments({ score: { $gt: userScore.score } });

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'User details retrieved successfully!'
        baseResponse.data = {
            UserScoreDetail: {
                ...userScore,
                rank: userRank + 1
            }
        }

        return res.status(200).json({...baseResponse});

    } catch (error) {
        next(error)
    }
}

const getTopTelegramUsers = async (req: Request, res: Response, next: NextFunction) => {
    try {
        // Find the top 5 Telegram users with the highest scores
        const topUsers = await TelegramUser.find({})
            .sort({ score: -1 })
            .limit(5)
            .lean()
            .exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'Top 5 Telegram users retrieved successfully!';
        baseResponse.data = {
            TopTelegramUsers: topUsers
        };

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error);
    }
}

const getStandardMocksBySubject = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const subject = req.query.subject?.toString();

        const mocks = await TelegramMock.find({subject, isStandard:true}).select("-questions -__v -createdAt -updatedAt").lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Mocks retrieved successfully!'
        baseResponse.data = {
           nationalMocks: mocks,
        }

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error);
    }
};

const getStandardMockQuestion = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const id = req.params.id;

        const mock = await TelegramMock.findOne({_id: id, isStandard:true}).select("-__v -createdAt -updatedAt").populate("questions").lean().exec();
        

        if (mock.questions && mock.questions.length > 0) {
            mock.questions = shuffleArray(mock.questions);
            mock.questions = mock.questions.slice(0, 20);
        }

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Mock questions retrieved successfully!'
        baseResponse.data = {
           nationalMock: mock,
        }

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error);
    }
};

const telegramBotControllers = {getCoursesBySubject, getCourseChapters, 
                                getChapterSubChapters, getSubChapterContents, 
                                getQuiz, addScore, getUserScore, 
                                getTopTelegramUsers, getStandardMocksBySubject, getStandardMockQuestion}

export default telegramBotControllers
