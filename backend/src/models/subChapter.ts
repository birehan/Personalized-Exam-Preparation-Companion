import { Document, Schema, model } from "mongoose";

export interface ISubChapter extends Document {
    name: String;
    contents: [Schema.Types.ObjectId];
    chapterId: Schema.Types.ObjectId;
    order: Number;
}

const SubChapterSchema: Schema<ISubChapter> = new Schema({
    chapterId: {
        type: Schema.Types.ObjectId,
        ref: 'Chapter',
        required: [true, "Chapter Id is required"]
    },
    name: {
        type: String,
        required: [true, "Sub-chapter name is required"]
    },
    order:{
        type: Number,
        default: 0
    },
    contents: {
        type: [{
            type: Schema.Types.ObjectId,
            ref: "SubChapterContent"
        }],
        default: []
    }
},
    {
        timestamps: {
            createdAt: 'createdAt',
            updatedAt: 'updatedAt'
        }
    }
);

const SubChapter = model<ISubChapter>("SubChapter", SubChapterSchema);

export default SubChapter;
