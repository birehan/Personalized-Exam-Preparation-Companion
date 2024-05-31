import { Document, Schema, model } from "mongoose";

export interface ITelegramUserQuestion extends Document {
    questionId: Schema.Types.ObjectId;
    telegramUser: Schema.Types.ObjectId;
}

const TelegramUserQuestionSchema: Schema<ITelegramUserQuestion> = new Schema({
    questionId: {
        type:Schema.Types.ObjectId,
        ref:'Question',
        required: [true, "Question Id is required"]
    },
    telegramUser: {
        type:Schema.Types.ObjectId,
        ref:'TelegramUser',
        required: [true, "TelegramUser Id is required"]
    }
},
    {
        timestamps: {
            createdAt: 'createdAt',
            updatedAt: 'updatedAt'
        }
    }
);

const TelegramUserQuestion = model<ITelegramUserQuestion>("TelegramUserQuestion", TelegramUserQuestionSchema);

export default TelegramUserQuestion;
