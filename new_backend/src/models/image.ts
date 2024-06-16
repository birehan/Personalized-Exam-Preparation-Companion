import mongoose, {Schema,Document} from "mongoose";

export interface IImage extends Document{
    imageAddress: String,
    cloudinaryId: String
}

const imageSchema: Schema<IImage> = new mongoose.Schema({
    imageAddress: {
        type: String
    },
    cloudinaryId: {
        type: String
    }
},
{
    timestamps: {
      createdAt: 'created_at',
      updatedAt: 'updated_at'
    }
})

const Image = mongoose.model<IImage>('Image',imageSchema)
export default Image