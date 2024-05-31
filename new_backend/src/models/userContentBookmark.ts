
import { Document, Schema, model } from "mongoose";

export interface IUserContentBookmark extends Document {
    userId : Schema.Types.ObjectId,
    contentId : Schema.Types.ObjectId,
    createdAt: Date
    updatedAt: Date
}

const UserContentBookmarkSchema: Schema<IUserContentBookmark> = new Schema({
    userId:{
    type: Schema.Types.ObjectId,
    ref: "User",
    required: [true,"User id is required"],
    },
    contentId: {
        type: Schema.Types.ObjectId, ref: "SubChapterContent",
        required: [true, "SubChapterContent id is required"]
    }
    },
    {
        timestamps: {
        createdAt: 'createdAt',
        updatedAt: 'updatedAt'
        }
    }
);

const UserContentBookmark = model<IUserContentBookmark>("UserContentBookmark", UserContentBookmarkSchema);

export default UserContentBookmark;
