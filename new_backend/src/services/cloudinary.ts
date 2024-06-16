import {v2 as cloudinary} from 'cloudinary'
import cloudinaryConfigs from '../config/cloudinary'

cloudinary.config({
  cloud_name: cloudinaryConfigs.CLOUD_NAME,
  api_key: cloudinaryConfigs.CLOUD_API_KEY,
  api_secret: cloudinaryConfigs.CLOUD_API_SECRET,
});

export default cloudinary
