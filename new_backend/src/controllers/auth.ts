// authRoutes.ts
import express from 'express';
import axios from 'axios';
import jwt from 'jsonwebtoken';
import * as dotenv from 'dotenv';
import User from '../models/user';
import configs from '../config/configs';
import { BaseResponse } from '../types/baseResponse';

dotenv.config();

const jwtSecret = configs.JWT_SECRET;

// create json web token that expires in AUTH_TOKEN_EXP_DAY
const maxAge = configs.AUTH_TOKEN_EXP_DAY * 24 * 60 * 60;
export const createToken = (id) => {
  return jwt.sign({ id }, jwtSecret, {
    expiresIn: maxAge
  });
};

// Define your token verification middleware
const userAuthWithToken = async (req: any, res: any, next: any) => {
    try {
        const idToken = req.body.idToken;
        const baseResponse = new BaseResponse();
        let examType = "University Entrance Exam";

        const userInfo = await verifyGoogleToken(idToken, process.env.GOOGLE_CLIENT_ID);

        const updatedName = userInfo.name + " " + "No_lastName";
        const name = updatedName.split(" ")
        const firstName = name[0]
        const lastName = name[1]
        const email_phone = userInfo.email;
        const password = "";

        const userByEmail = await User.findOne({ email_phone, }).lean().exec();

        //if user found return error
        if (userByEmail) {
            if(!userByEmail.isGoogleSignup){
                throw Error("That email is already registered");
            }

            const token = createToken(userByEmail);
            res.header('token', token);
            res.cookie('jwt', token, { httpOnly: true, maxAge: maxAge * 1000 });

            const cur_user = await User.findOne({ _id: userByEmail._id }).populate("department", "select _id name")
            .populate("avatar", "select imageAddress -_id")
            .select('-__v -password -createdAt -updatedAt -resetToken')
            .lean().exec();

            baseResponse.success = true
            baseResponse.message = 'User signed in successfully'
            baseResponse.data = {
                token: token,
                curUser: cur_user,
                examType,
            }
            return res.status(201).json({ ...baseResponse }).end();
        }

        // Create new user with an empty password
        const newUser = new User({ firstName, lastName, email_phone, password });

        newUser.isGoogleSignup = true;

        const savedUser = await newUser.save({ validateBeforeSave: false });

        //send jwt token
        const token = createToken(savedUser);
        res.header('token', token);
        res.cookie('jwt', token, { httpOnly: true, maxAge: maxAge * 1000 });

        const cur_user = await User.findOne({ _id: savedUser._id }).populate("department", "select _id name")
        .populate("avatar", "select imageAddress -_id")
        .select('-__v -password -createdAt -updatedAt -resetToken')
        .lean().exec();

        baseResponse.success = true
        baseResponse.message = 'User registered in successfully'
        baseResponse.data = {
            token: token,
            curUser: cur_user,
            examType,
        }
        return res.status(201).json({ ...baseResponse }).end();
    } catch (error) {
        next(error)
    }
};


const verifyGoogleToken = async (idToken: string, googleClientID: string) => {
  try {
    const googleTokenInfoURL = `https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=${idToken}`;
    const response = await axios.get(googleTokenInfoURL);

    if (response.status !== 200) {
        throw new Error('Failed to verify Google token');
    }

    const tokenInfo = response.data;

    if (tokenInfo.azp !== googleClientID) {
        throw new Error('Invalid audience in Google token');
    }

    const userInfo = {
        name: tokenInfo.name,
        email: tokenInfo.email,
        picture: tokenInfo.picture
    };

    return userInfo;
    
  } catch (error) {
    throw Error("Invalid token sent!")
  }
};

const userAuthControllers = {
    userAuthWithToken
};

export default userAuthControllers;
