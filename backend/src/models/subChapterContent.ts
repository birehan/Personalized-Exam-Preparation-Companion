
import { Document, Schema, model } from "mongoose";

export interface SubChapterContent extends Document {
//   id: Schema.Types.ObjectId;
  title: String;
  content: String;
  subChapterId: Schema.Types.ObjectId;
  order: Number;
}

const SubChapterContentSchema: Schema<SubChapterContent> = new Schema({
  title:{
    type: String,
    required:[true,"Sub Chapter Content title is required"]
  },
  content: {
    type: String,
    required: [true, "Sub Chapter Contant is required"]
   
  },
  subChapterId: {
    type: Schema.Types.ObjectId,
    ref:'SubChapter',
    required: [true, "Sub Chapter id is required"]
  },
  order:{
    type: Number,
    default: 0
},

},
{
    timestamps: {
      createdAt: 'createdAt',
      updatedAt: 'updatedAt'
    }
  }
);

const SubChapterContent = model<SubChapterContent>("SubChapterContent", SubChapterContentSchema);

export default SubChapterContent;
