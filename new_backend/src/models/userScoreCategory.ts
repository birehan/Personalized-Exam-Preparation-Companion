import { Document, Schema, model } from "mongoose";

export interface IUserScoreCategory extends Document {
    start: number;
    end: number;
    count: number;
    percentile: number;
    top: number;
}

const UserScoreCategorySchema: Schema<IUserScoreCategory> = new Schema({
    start: {
        type: Number,
        required: true,
    },
    end: {
        type: Number,
        required: true,
    },
    count: {
        type: Number,
        default: 0,
    },
    percentile: {
        type: Number,
        default: 0,
    },
    top: {
        type: Number,
        required: true,
    },
},
{
    timestamps: true,
});

const UserScoreCategory = model<IUserScoreCategory>("UserScoreCategory", UserScoreCategorySchema);

export default UserScoreCategory;
