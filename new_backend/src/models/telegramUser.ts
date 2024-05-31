
import { Document, Schema, model } from "mongoose";
export interface ITelegramUser extends Document {
    telegramUserId: String;
    score: Number;
}

const TelegramUserSchema: Schema<ITelegramUser> = new Schema({
    telegramUserId: {
        type: String,
        unique: true,
        required: [true, "telegramUserId name is required"]
    },
    score: {
        type: Number,
        default:0
    }
},
    {
        timestamps: {
            createdAt: 'createdAt',
            updatedAt: 'updatedAt'
        }
    }
);

const TelegramUser = model<ITelegramUser>("TelegramUser", TelegramUserSchema);

export default TelegramUser;
