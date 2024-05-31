import dotenv from 'dotenv'

dotenv.config();
const CLOUD_NAME = process.env.CLOUD_NAME 
const CLOUD_API_KEY = process.env.CLOUD_API_KEY 
const CLOUD_API_SECRET = process.env.CLOUD_API_SECRET 
const FOLDER_NAME = process.env.FOLDER_NAME 
const CLOUDINARY_URL = process.env.CLOUDINARY_URL  

const cloudinaryConfigs = {
    CLOUD_NAME,
    CLOUD_API_KEY,
    CLOUD_API_SECRET,
    FOLDER_NAME,
    CLOUDINARY_URL
}

export default cloudinaryConfigs;