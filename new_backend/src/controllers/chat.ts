import { Request, Response, NextFunction } from 'express';
import { BaseResponse } from '../types/baseResponse';
import Question from "../models/question";
import configs from '../config/configs'
import OpenAI from 'openai';
import { firstPromptForContent, firstPromptForQuestion, generalPrompt, teacherPrompt } from '../types/chatPromps';
import SubChapterContent from '../models/subChapterContent';
import SubChapter from '../models/subChapter';
import Chapter from '../models/chapter';
import Course from '../models/course';
import { logUserDailyActivity } from '../services/helpers';
import ContestQuestion from '../models/contestQuestion';

const userChatQuestion = async (req: Request, res: Response, next: NextFunction) => {
  try {

      const userId = req.body.user._id.toString();
      const { userQuestion, chatHistoryObj, questionId, isContest } = req.body;

      const isContestBool = Boolean(isContest) || false

      let questionObj;
  
      if (isContestBool) {
        questionObj = await ContestQuestion.findOne({_id: questionId}).select("-_id description choiceA choiceB choiceC choiceD answer explanation").lean().exec();
      } else {
        questionObj = await Question.findOne({_id: questionId}).select("-_id description choiceA choiceB choiceC choiceD answer explanation").lean().exec();
      }
      const openai = new OpenAI({
        apiKey: process.env.OPENAI_API_KEY,
      });
    
      const firstHistory = firstPromptForQuestion(questionObj);

      const user_input = userQuestion;

      const messages = [];
      messages.push({ role: "system", content: teacherPrompt});
      messages.push({ role: "user", content:  firstHistory[0]});
      messages.push({ role: "assistant", content:  firstHistory[1]});

      for (const [input_text, completion_text] of chatHistoryObj) {
        messages.push({ role: "user", content: input_text });
        messages.push({ role: "assistant", content: completion_text });
      }

      messages.push({ role: "user", content: user_input });

      const completion = await openai.chat.completions.create({
        model: "gpt-3.5-turbo",
        messages: messages,
        max_tokens: 200
      })

      const completion_text = completion.choices[0].message.content;

      chatHistoryObj.push([user_input, completion_text]);
      await logUserDailyActivity(userId, new Date(), 'questionChat')


      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'User chat response successful!';
      baseResponse.data = {
        history: chatHistoryObj,
      };
    
      return res.status(201).json(baseResponse);
    
  } catch (error) {
    next(error)
  }
};

const userChatContent = async (req: Request, res: Response, next: NextFunction) => {
  try {

    const userId = req.body.user._id.toString();
    const { userQuestion, chatHistoryObj, contentId } = req.body;

    const contentObj = await SubChapterContent.findOne({_id: contentId}).select("-_id title content subChapterId").lean().exec();

    if (!contentObj) {
      throw new Error('No SubChapterContent found with that ID');
    }

    const subChapter = await SubChapter.findOne({_id: contentObj.subChapterId}).select("-_id name chapterId").lean().exec();
    const chapter = await Chapter.findOne({_id: subChapter.chapterId}).select("-_id name description courseId").lean().exec();
    const course = await Course.findOne({_id: chapter.courseId}).select("-_id name description referenceBook").lean().exec();

    const openai = new OpenAI({
      apiKey: process.env.OPENAI_API_KEY,
    });
  
    const firstHistory = firstPromptForContent(contentObj, course, chapter, subChapter);

    const user_input = userQuestion;

    const messages = [];
    messages.push({ role: "system", content: teacherPrompt});
    messages.push({ role: "user", content:  firstHistory[0]});
    messages.push({ role: "assistant", content:  firstHistory[1]});

    for (const [input_text, completion_text] of chatHistoryObj) {
      messages.push({ role: "user", content: input_text });
      messages.push({ role: "assistant", content: completion_text });
    }

    messages.push({ role: "user", content: user_input });

    const completion = await openai.chat.completions.create({
      model: "gpt-3.5-turbo",
      messages: messages,
      max_tokens: 200
    })

    const completion_text = completion.choices[0].message.content;

    chatHistoryObj.push([user_input, completion_text]);

    await logUserDailyActivity(userId, new Date(), 'contentChat')

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'User Chat response successful!';
    baseResponse.data = {
      history: chatHistoryObj,
    };
  
    return res.status(201).json(baseResponse);
    
  } catch (error) {
    next(error)
  }
};

const userGeneralChat = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const userId = req.body.user._id.toString();
    const userCurrentPage = req.query.currentPage?.toString()|| "Home page";

    const { userQuestion, chatHistoryObj } = req.body;

    const openai = new OpenAI({
      apiKey: process.env.OPENAI_API_KEY,
    });
  
    const AssistantPrompt = generalPrompt(userCurrentPage);

    const user_input = userQuestion;

    const messages = [];
    messages.push({ role: "system", content: AssistantPrompt});

    for (const [input_text, completion_text] of chatHistoryObj) {
      if (input_text === null || input_text === "") {
        console.log(input_text)
        continue
      }
      messages.push({ role: "user", content: input_text });
      messages.push({ role: "assistant", content: completion_text });
    }

    messages.push({ role: "user", content: user_input });

    const completion = await openai.chat.completions.create({
      model: "gpt-3.5-turbo",
      messages: messages,
      max_tokens: 200
    })

    const completion_text = completion.choices[0].message.content;

    chatHistoryObj.push([user_input, completion_text]);

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'User Chat response successful!';
    baseResponse.data = {
      history: chatHistoryObj,
    };
  
    return res.status(201).json(baseResponse);
    
  } catch (error) {
    next(error)
  }
};


const chatControllers = {userChatQuestion, userChatContent, userGeneralChat}

export default chatControllers