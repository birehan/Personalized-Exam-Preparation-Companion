import { NextFunction, Request, Response } from 'express'
import DataURIParser from 'datauri/parser';
import { upload } from '../services/upload';

const imageFormats = [".jpg", ".jpeg", ".png", "jpg", "jpeg", "png", "octet-stream"]
interface FileRequest extends Request{
  files: any;
}
const isValidFormat = (fileFormat) => {
  let isValidFile = false
  for(let i=0; i < imageFormats.length; i++){
    if(fileFormat === imageFormats[i]){
      isValidFile = true
      break
    }
  }
  return isValidFile
}
export default async function uploader (req:FileRequest, res:Response, next:NextFunction) {
    try {
      let pictureFiles = req.files;
      if (!req.files){
        return next()
      }
      
      let multiplePicturePromise = []
      const parser = new DataURIParser()
      for (let i=0; pictureFiles.image && i<pictureFiles.image.length; i++){
          const image = await upload(req,res,next,pictureFiles.image[i],isValidFormat)
          multiplePicturePromise.push(image)
      }
     
      if (pictureFiles.image && !pictureFiles.image.length){
          const image = await upload(req,res,next,pictureFiles.image,isValidFormat)
          multiplePicturePromise.push(image)
      }


      //If there is avatar sent add the avatar to body
      if (pictureFiles.avatar && !pictureFiles.avatar.length){
          const avatar = await upload(req,res,next,pictureFiles.avatar,isValidFormat)
          req.body.avatar = avatar
      }

      if (pictureFiles.logo && !pictureFiles.logo.length){
        const logo = await upload(req,res,next,pictureFiles.logo,isValidFormat)
        req.body.logo = logo
      }

      if (pictureFiles.countryFlag && !pictureFiles.countryFlag.length){
        const countryFlag = await upload(req,res,next,pictureFiles.countryFlag,isValidFormat)
        req.body.countryFlag = countryFlag
      }
      //if multiple images are need in the following c
      req.body.image = multiplePicturePromise[0]
      next()
      return
    } catch (err) {
      next(err)
      return
    }
  }

