import { Document, Schema, model } from "mongoose";

export interface IQuestionUserAnswer extends Document {
    //   courseId: Schema.Types.ObjectId;
    questionId: Schema.Types.ObjectId;
    userId: Schema.Types.ObjectId;
    userAnswer: String;
    createdAt: Date,
    updatedAt: Date
}

export enum QuestionAnswers {
    A = "choice_A",
    B = "choice_B",
    C = "choice_C",
    D = "choice_D",
    E = "choice_E",
  }

const QuestionUserSchema: Schema<IQuestionUserAnswer> = new Schema({
    questionId: {
        type:Schema.Types.ObjectId,
        ref:'Question',
        required: [true, "Question Id is required"]
    },
    userId: {
        type:Schema.Types.ObjectId,
        ref:'User',
        required: [true, "User Id is required"]
    },
    userAnswer: {
        type:String,
        enum: QuestionAnswers,
        required: [true, "userAnswer is required"]
    }
},
    {
        timestamps: {
            createdAt: 'createdAt',
            updatedAt: 'updatedAt'
        }
    }
);

const QuestionUserAnswer = model<IQuestionUserAnswer>("QuestionUserAnswer", QuestionUserSchema);

export default QuestionUserAnswer;
