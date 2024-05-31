import DataURIParser from "datauri/parser";
import { Request, Response, NextFunction } from "express";
import cloudinary from '../services/cloudinary';
import Image from "../models/image";
import cloudinaryConfigs from '../config/cloudinary'

const parser = new DataURIParser()
export const upload = async(req: Request, res: Response, next: NextFunction, file:any, isValidFormat:any) => {
    const fileFormat = file.mimetype.split('/')[1] 
    const { base64 } = parser.format(fileFormat,file.data);

    if (!isValidFormat(fileFormat)) {
      throw new Error(`Invalid image format sent!`)
    }

    const result =  await cloudinary.uploader.upload(`data:image/${fileFormat};base64,${base64}`, { folder: cloudinaryConfigs.FOLDER_NAME})

    const data = {
        imageAddress: `${result.secure_url}`,
        cloudinaryId: `${result.public_id}`
    };

    const image = await Image.create({...data})
    return image._id.toString()
}