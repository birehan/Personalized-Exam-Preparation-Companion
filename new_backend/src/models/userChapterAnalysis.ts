import { Document, Schema, model } from "mongoose";

export interface IUserChapterAnalysis extends Document {
  userId: Schema.Types.ObjectId;
  chapterId: Schema.Types.ObjectId;
  completedSubChapters: [Schema.Types.ObjectId];
}

const UserChapterAnalysisSchema: Schema<IUserChapterAnalysis> = new Schema({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: [true, "User Id is required"]
  },
  chapterId: {
    type: Schema.Types.ObjectId,
    ref: 'Chapter',
    required: [true, "Chapter Id is required"]
  },
  completedSubChapters: {
    type: [{ type: Schema.Types.ObjectId, ref: "SubChapter" }],
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

const UserChapterAnalysis = model<IUserChapterAnalysis>("UserChapterAnalysis", UserChapterAnalysisSchema);

export default UserChapterAnalysis;