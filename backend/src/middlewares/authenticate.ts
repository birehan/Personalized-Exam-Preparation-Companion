import { Request, Response, NextFunction} from 'express'
import User, { IUserDocument, userValidation } from '../models/user'
import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';

dotenv.config()
const jwtSecret = process.env.JWT_SECRET;

const isAuthenticated = (req: Request, res:Response, next: NextFunction) => {
  let token = req.headers['authorization'] || req.body.token || req.headers.cookie?.split('=')[1] || req.cookies?.jwt;
  
  if (token) {
    const bearer = token.split(' ');
    if(bearer.length == 2){
      token = bearer[1];
    }else{
      token = bearer[0];
    }
    jwt.verify(token, jwtSecret, async (err, decodedToken) => {
      if (err) {
        return res.status(400).json({ error: {msg: "User not authenticated. The token sent is bad or expired."}}).end();
      } else {
        let user = await (await User.findById(decodedToken.id._id));
        if(!user){
          return res.status(400).json({ error: {msg: "User not authenticated or token sent is bad or expired."}}).end();
        }
        req.body.user = user;
        next();
      }
    });
  } else {
      return res.status(400).json({ error: {msg: "User not authenticated!"}}).end();
  }
};

export default isAuthenticated;