import { Request, Response, NextFunction} from 'express'
import User, { IUserDocument, userValidation } from '../models/user'
import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';
import { BaseResponse } from '../types/baseResponse';

dotenv.config()
const jwtSecret = process.env.JWT_SECRET;

const isAuthenticated = (req: Request, res:Response, next: NextFunction) => {
  let token = req.headers['authorization'] || req.body.token || req.headers.cookie?.split('=')[1] || req.cookies?.jwt;
  let baseResponse = new BaseResponse();
  
  if (token) {
    const bearer = token.split(' ');
    if(bearer.length == 2){
      token = bearer[1];
    }else{
      token = bearer[0];
    }
    jwt.verify(token, jwtSecret, async (err, decodedToken) => {
      if (err) {
        baseResponse.success = false;
        baseResponse.message = 'User not authenticated. The token sent is expired.';
        baseResponse.errors.push("User not authenticated. The token sent is expired.")
        return res.status(401).json({ ...baseResponse}).end();
      } else {
        let user = await (await User.findById(decodedToken.id._id));
        if(!user){
          baseResponse.success = false;
          baseResponse.message = 'User not authenticated. The token sent is bad.';
          baseResponse.errors.push("User not authenticated. The token sent is bad.")
          return res.status(400).json({...baseResponse}).end();
        }
        req.body.user = user;
        next();
      }
    });
  } else {
      baseResponse.success = false;
      baseResponse.message = 'User not authenticated. The token sent is bad.';
      baseResponse.errors.push("User not authenticated. The token sent is bad.");
      return res.status(400).json({ ...baseResponse}).end();
  }
};

export default isAuthenticated;