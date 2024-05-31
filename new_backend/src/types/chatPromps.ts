import SubChapter from "../models/subChapter";
import dotenv from 'dotenv';

dotenv.config();

export const firstPromptForQuestion = (questionObj) => {
    const prompt = `
        I want to ask you some questions on the following multiple choice question.
        Question: ${questionObj.description}
        Choice A: ${questionObj.choiceA}
        Choice B: ${questionObj.choiceB}
        Choice C: ${questionObj.choiceC}
        Choice D: ${questionObj.choiceD}
        With provided answer: ${questionObj.answer} and explanation: ${questionObj.explanation}.
        
        The following conversation will be tailored to the above question. Going forward, if a question I ask you is out of the context of the question, you can tell me that it's out of context and still answer the question in very short sentences.
        
        Do you understand my request?
    `;

    const response = "Yes, I understand your request. You would like to ask me some questions based on a multiple-choice question format, and you've provided the question, answer choices, the correct answer, and an explanation for each question. I'll provide responses tailored to each question you ask. Please go ahead and ask the first question.";

    return [prompt, response];
}

export const firstPromptForContent = (contentObj, course, chapter, subChapter) => {
    const prompt = `
        I want to ask you some questions on the following content that is taken from the 
        course: ${course.name}, with course description: ${course.description} and with course reference book: ${course.referenceBook}
        And of Topic: ${chapter.name} with description: ${chapter.description} and sub-topic: ${subChapter.name}.
        Here is the specific content i want to ask you questions about: ${contentObj.description}
        
        The following conversation will be tailored to the above content. Going forward, if a question I ask you is out of the context of the content, you can tell me that it's out of context and still answer the question in very short sentences.
        
        Do you understand my request?
    `;

    const response = "Yes, I understand your request. You would like to ask questions about specific content from a course, chapter, and sub-topic, and I will provide answers tailored to that context. If a question goes out of context, I will inform you but still provide a brief answer. Please go ahead and ask your questions."

    return [prompt, response]
}

export const teacherPrompt = "You are an intelligent and dedicated educational assistant named Professor Learnalot. Your mission is to help students with their questions and provide guidance on their learning journey. Just like a trusted teacher, you're always ready to share knowledge and support students in their quest for understanding.";

export const generalPrompt = (userCurrentPage) => {
    const  GeneralAssistantPrompt = process.env.ASSISTANT_PROMPT || teacherPrompt
    const finalPrompt = GeneralAssistantPrompt + ` 
        The student is currently on the ${userCurrentPage} page.
    `;
    return finalPrompt
}