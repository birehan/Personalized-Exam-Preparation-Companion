import { Request, Response, NextFunction } from 'express'
import jwt from 'jsonwebtoken';

import Otp, { IOtp } from '../models/otp'
import { BaseResponse } from '../types/baseResponse';
import nodemailer from 'nodemailer';
import bcrypt from 'bcrypt';
import User, { IUserDocument, userValidation, updateUserValidation } from '../models/user'
import configs from '../config/configs'
import { verificationHTML } from '../types/staticContent';
import axios from 'axios';
import { decryptData, getUserconsistency, isEmailOrPhoneNumber, logActiveUser, updateCoinIncentivization } from '../services/helpers';
import UserChapterAnalysis from '../models/userChapterAnalysis';
import Chapter from '../models/chapter';
import Mock from '../models/mock';
import UserMock from '../models/userMock';
import ExamDate from '../models/examDate';
import UserCourseAnalysis from '../models/userCourseAnalysis';
import QuestionUserAnswer from '../models/questionUserAnswer';
import leaderboardController from './userLeaderBoard';
import DailyActivity from '../dashboard/models/dailyActivity';
import UserStatistics from '../models/userStatistics';
import mongoose from 'mongoose';
import UserScoreCategory from '../models/userScoreCategory';
import CoinIncentivization from '../models/coinIncentivization';
import { google } from "googleapis";


const jwtSecret = configs.JWT_SECRET;

//Nodemailer setup
// const transporter = nodemailer.createTransport({
//   service: "gmail",
//   auth: {
//     user: configs.EMAIL,
//     pass: configs.PASSWORD,
//   }
// })
const OAuth2 = google.auth.OAuth2;

const oauth2Client = new OAuth2(
  configs.OAUTH_CLIENT_ID,
  configs.OAUTH_CLIENT_SECRET,
  "https://developers.google.com/oauthplayground" // Redirect URL
);

oauth2Client.setCredentials({
  refresh_token: configs.OAUTH_REFRESH_TOKEN,
});
const accessToken = oauth2Client.getAccessToken();

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    type: "OAuth2",
    user: configs.EMAIL,
    pass: configs.PASSWORD,
    clientId: configs.OAUTH_CLIENT_ID,
    clientSecret: configs.OAUTH_CLIENT_SECRET,
    refreshToken: configs.OAUTH_REFRESH_TOKEN,
    accessToken: accessToken,
  },
});

// create json web token that expires in AUTH_TOKEN_EXP_DAY
const maxAge = configs.AUTH_TOKEN_EXP_DAY * 24 * 60 * 60;
export const createToken = (id) => {
  return jwt.sign({ id }, jwtSecret, {
    expiresIn: maxAge
  });
};

const userLogin = async (req: Request, res: Response, next) => {

  try {
    let { email_phone, password } = req.body;
    email_phone = email_phone.trim()
    password = password.trim()

    let baseResponse = new BaseResponse();

    if (email_phone === null || password === null || email_phone === "" || password == "") {
      throw Error("Must provide Email/Phone_Number and password.");
    }
    const user: IUserDocument = await User.login(email_phone, password);

    const token = createToken(user);

    res.header('token', token);
    res.cookie('jwt', token, { httpOnly: true, maxAge: maxAge * 1000 });

    const cur_user = await User.findOne({ _id: user._id }).populate("department", "select _id name")
    .populate("avatar", "select imageAddress -_id")
    .select('-__v -password -createdAt -updatedAt -resetToken')
    .lean().exec();

    let examType = "University Entrance Exam";

    baseResponse.success = true
    baseResponse.message = 'User logged in successfully'
    baseResponse.data = {
      token: token,
      curUser: cur_user,
      examType,
    }
    return res.status(200).json({ ...baseResponse });
  }
  catch (err) {
    if (err.isJoi === true) {
      next(Error(err.details[0].message));
    }
    next(err);
  }
}

//TODO: should work for both email and phone number. Change User's email attribute to email_phone
const userSignup = async (req, res, next) => {
  try {
    let { firstName, lastName, email_phone, password, otp, referredBy } = req.body;

    let baseResponse = new BaseResponse();

    const validatedUser = await userValidation.validateAsync( { firstName, lastName, email_phone, password });

    //check if user exists with email
    const userByEmail = await User.findOne({ email_phone: validatedUser.email_phone }).lean().exec();

    //if user found return error
    if (userByEmail) {
      throw Error("That email is already registered");
    }

    const verifyUserOTP = await verifyUserAndOtp({ email_phone, otp });
    if (verifyUserOTP.isValid !== true) {
      throw Error(verifyUserOTP.error);
    }

    const new_user = await User.create({ ...validatedUser });

    if (referredBy && mongoose.Types.ObjectId.isValid(referredBy)){
      
      const res= await updateCoinIncentivization(referredBy, configs.REFERRAL_INCENTIVE, 'referral')
    }

    //send jwt token
    const token = createToken(new_user);
    res.header('token', token);
    res.cookie('jwt', token, { httpOnly: true, maxAge: maxAge * 1000 });

    const cur_user = await User.findOne({ _id: new_user._id }).populate("department", "select _id name")
    .populate("avatar", "select imageAddress -_id")
    .select('-__v -password -createdAt -updatedAt -resetToken')
    .lean().exec();

    let examType = "University Entrance Exam";

    baseResponse.success = true
    baseResponse.message = 'User registered in successfully'
    baseResponse.data = {
      token: token,
      curUser: cur_user,
      examType,
    }
    return res.status(201).json({ ...baseResponse }).end();
  }
  catch (err) {
    if (err.isJoi === true) {
      next(Error(err.details[0].message));
    }
    next(err);
  }
}



//verify OTP before login || TODO: Should work for both phone number and email
const verifyUserAndOtp = async ({ email_phone, otp }) => {
  try {
    if (!email_phone || !otp) {
      return { isValid: false, error: "Empty user details is not allowed!" }
    } else {
      const otpVerificationRecord = await Otp.find({ email_phone }).lean().exec();
      if (otpVerificationRecord.length <= 0) {
        return { isValid: false, error: "Incorrect verification code sent." }
      } else {

        const { expiresAt } = otpVerificationRecord[0];
        const hashedOtp = otpVerificationRecord[0].otp;

        if (expiresAt.getTime() < Date.now()) {
          return { isValid: false, error: "Verification code has expired. Please request again." }
        } else {

          const validOTP = await bcrypt.compare(otp, hashedOtp);

          if (!validOTP) {
            return { isValid: false, error: "Invalid code passed. Please check your inbox again." }
          } else {

            await Otp.deleteMany({ email_phone }).lean().exec();
            return { isValid: true, error: "" };
          }
        }
      }
    }
  } catch (error) {
    return { isValid: false, error: "failed to verify OTP" }
  }
}


//SEND OTP Verification to Email(to be called from routes) || TODO: should work for both email and phone number 
const sendOtpVerification = async (req, res, next) => {
  try {
    const { email_phone } = req.body;
    if (!email_phone) {
      throw Error("Empty email/Phone_number details are not allowed!");
    }

    //check if email_phone is phone or email
    const result = isEmailOrPhoneNumber(email_phone);
    if (result === "Phone Number"){
      return await sendOTPSMS({ phoneNumber: email_phone }, res);
    }
    else if (result === "Email") {
      console.log("hello");
      console.log(email_phone);
      console.log("heelo");
      return await sendOtp({ email: email_phone }, res);
    }
    else {
      throw Error("Email/Phone_number sent is invalid!");
    }
    
  } catch (error) {
    next(error)
  }
}

const forgotPassSendOtpVerification = async (req, res, next) => {
  try {
    const { email_phone } = req.body;
    
    if (!email_phone) {
      throw Error("Empty email/Phone_number details are not allowed!");
    }
    const foundUser = await User.findOne({email_phone,}).lean().exec();

    if (!foundUser){ throw Error("No user account created with that credential!");}

    //check if email_phone is phone or email
    const result = isEmailOrPhoneNumber(email_phone);
    if (result === "Phone Number"){
      return await sendOTPSMS({ phoneNumber: email_phone }, res);
    }
    else if (result === "Email") {
      return await sendOtp({ email: email_phone }, res);
    }
    else {
      throw Error("Email/Phone_number sent is invalid!");
    }
    
  } catch (error) {
    next(error)
  }
}

//OTP verification setup via Email
// const sendOtp = async ({ email }, res) => {
//   console.log("email" + configs.EMAIL);
//   console.log("password" + configs.PASSWORD);

//   email.trim();

//   if (email == "" || !email) {
//     throw Error("Empty email is not allowed.");
//   }
//   try {
//     const otpRecord = await Otp.find({ email_phone: email }).lean().exec();
    
//     if (otpRecord.length > 0) {
//       const result = await Otp.deleteMany({ email_phone: email }).lean().exec();
//     }

//     const otp = `${Math.floor(100000 + Math.random() * 900000)}`;


//     //setup mail options
//     const mailOptions = {
//       from: configs.EMAIL,
//       to: email,
//       subject: "SkillBridge Account Verification",
//       html: verificationHTML(otp)
//     };
    
  
//     const salt = await bcrypt.genSalt();
//     const hashedOtp = await bcrypt.hash(otp, salt);
//     const newOtp = new Otp({
//       email_phone: String(email),
//       otp: hashedOtp,
//       createdAt: Date.now(),
//       expiresAt: Date.now() + 300000
//     });
//     console.log("hello again");
//     const savedOTP = await newOtp.save();
//     const result = await transporter.sendMail(mailOptions);

//     console.log("hello again last");
    
//     let baseResponse = new BaseResponse();
//     baseResponse.success = true
//     baseResponse.message = "Verification otp Email sent successfully!"
//     baseResponse.data = {
//       status: "PENDING"
//     }
//     return res.status(201).json({ ...baseResponse }).end();

//   } catch (error) {
//     throw error;
//   }
// }

const sendOtp = async ({ email }, res) => {
  email.trim();

  if (email == "" || !email) {
    throw Error("Empty email is not allowed.");
  }
  try {
    const otpRecord = await Otp.find({ email_phone: email }).lean().exec();

    if (otpRecord.length > 0) {
      const result = await Otp.deleteMany({ email_phone: email }).lean().exec();
    }

    const otp = `${Math.floor(100000 + Math.random() * 900000)}`;

    //setup mail options
    const mailOptions = {
      from: configs.EMAIL,
      to: email,
      subject: "PrepGenie Account Verification",
      html: verificationHTML(otp),
    };

    console.log("mail options: ");
    console.log(mailOptions);

    const salt = await bcrypt.genSalt();
    const hashedOtp = await bcrypt.hash(otp, salt);
    const newOtp = new Otp({
      email_phone: String(email),
      otp: hashedOtp,
      createdAt: Date.now(),
      expiresAt: Date.now() + 300000,
    });

    const savedOTP = await newOtp.save();
    
    console.log("otp saved");
    const result = await transporter.sendMail(mailOptions);
    console.log("otp sent")

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = "Verification otp Email sent successfully!";
    baseResponse.data = {
      status: "PENDING",
    };
    return res
      .status(201)
      .json({ ...baseResponse })
      .end();
  } catch (error) {
    console.log("error: ", error);
    throw error;
  }
};


//Send OTP via 
const sendOTPSMS = async ({ phoneNumber }, res) => {
  try{
      phoneNumber.trim();

      if (phoneNumber == "" || !phoneNumber) {
        throw Error("Empty phoneNumber is not allowed.");
      }
      const otpRecord = await Otp.find({ email_phone: phoneNumber }).lean().exec();
      
      if (otpRecord.length > 0) {
        const result = await Otp.deleteMany({ email_phone: phoneNumber }).lean().exec();
      }

      const otp = `${Math.floor(100000 + Math.random() * 900000)}`;


      //setup mail options
      const message = `This is from SkillBridge. Your verification code is: ${otp}. It will expire in 5 Mins! Thank You!`;
      

      const salt = await bcrypt.genSalt();
      const hashedOtp = await bcrypt.hash(otp, salt);
      const newOtp = new Otp({
        email_phone: String(phoneNumber),
        otp: hashedOtp,
        createdAt: Date.now(),
        expiresAt: Date.now() + 300000
      });

      const savedOTP = await newOtp.save();

      axios({
        url: process.env.SMS_URL,
        method: "POST",
        data: {
            'msg': message,
            'phone': phoneNumber,
            'token': process.env.SMS_TOKEN
        }
      })

      let baseResponse = new BaseResponse();
      baseResponse.success = true
      baseResponse.message = "Verification otp Email sent successfully!"
      baseResponse.data = {
        status: "PENDING"
      }
      return res.status(201).json({ ...baseResponse }).end();
  }catch(err){
    throw err;
  }
}

//resend verification
const resendOtpVerification = async (req, res, next) => {
  const { email_phone } = req.body;
  try {
    const { email_phone } = req.body;
    if (!email_phone) {
      throw Error("Empty email/Phone_number details are not allowed!");
    }

    //check if email_phone is phone or email
    const result = isEmailOrPhoneNumber(email_phone);
    if (result === "Phone Number"){
      return await sendOTPSMS({ phoneNumber: email_phone }, res);
    }
    else if (result === "Email") {
      return await sendOtp({ email: email_phone }, res);
    }
    else {
      throw Error("Email/Phone_number sent is invalid!");
    }
  } catch (error) {
    next(error)
  }
}

//TODO: user change Password
const changePassword = async (req: Request, res: Response, next) => {
  const { oldPassword, newPassword, confirmPassword } = req.body
  try {
    oldPassword.trim()
    newPassword.trim()
    confirmPassword.trim()
    if (!oldPassword || !newPassword || !confirmPassword || oldPassword === "" || newPassword === "" || confirmPassword === "") {
      throw Error("Empty fields are not allowed")
    }
    
    if (!req.body.user) {
      throw Error("User not Authenticated")
    }
    
    if (newPassword !== confirmPassword) {
      throw Error("Wrong password confirmation!")
    }
    
    if (newPassword.length < 6) {
      throw Error("Password length should be greater than 6!")
    }
    
    if(req.body.user.password !== "" && req.body.user.password !== null){
      const isValid = await bcrypt.compare(oldPassword, req.body.user.password);
      if (!isValid) {
        throw Error("Wrong Old password!")
      }
    }
    
    const salt = await bcrypt.genSalt();
    const hashedPassword = await bcrypt.hash(newPassword, salt);

    const changedUser = await User.findOneAndUpdate(
      { _id: req.body.user._id },
      {
        password: hashedPassword
      }
    ).lean().exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true
    baseResponse.message = 'Password changed successfully!'
    baseResponse.data = {
      status: "password changed"
    }

    return res.status(200).json({ ...baseResponse })

  } catch (error) {
    next(error)
  }
};

//Forgot Password
const userForgotPassVerifyOTP = async (req: Request, res: Response, next) => {
  try {
    const { email_phone, otp } = req.body;
    
    if (!email_phone || email_phone==="" || !otp || otp==="") {
      throw Error("User credential and OTP are required!");
    }

    const user: IUserDocument = await User.findOne({ email_phone, });

    if (!user) throw Error("User doesn't exits with that Email.")

    const otpVerification = await verifyUserAndOtp({ email_phone, otp })

    if (!otpVerification.isValid) {
      throw Error(otpVerification.error)
    }

    const salt = await bcrypt.genSalt();
    const resetToken = await bcrypt.hash(otp, salt);
    user.resetToken = resetToken
    await User.findByIdAndUpdate(user._id, { ...user }).lean().exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true
    baseResponse.message = 'OTP verified successfully'
    baseResponse.data = {
      email_phone: email_phone,
      otp: otp
    }
    return res.status(200).json({ ...baseResponse });
  }
  catch (error) {
    next(error)
  }
}

const forgotChangePassword = async (req: Request, res: Response, next) => {
  const { email_phone, newPassword, confirmPassword, otp } = req.body
  try {
    if (!email_phone || !otp || !newPassword || !confirmPassword || otp === "" || newPassword === "" || confirmPassword == "" || email_phone === "") {
      throw Error("Empty fields are not allowed")
    }
    
    if (newPassword !== confirmPassword) {
      throw Error("Wrong password confirmation!")
    }
    
    if (newPassword.length < 6) {
      throw Error("Password length should be greater than 6!")
    }
    
    const user = await User.findOne({ email_phone, })

    if(!user){
      throw Error("No user found with that email/phone_number!")
    }

    const isValid = await bcrypt.compare(otp, user.resetToken);

    if (!isValid) {
      throw Error("Wrong OTP verification code sent!")
    }
    
    const salt = await bcrypt.genSalt();
    const hashedPassword = await bcrypt.hash(newPassword, salt);

    const changedUser = await User.findOneAndUpdate(
      { _id: user._id },
      {
        password: hashedPassword,
        resetToken: ""
      }
    )

    let baseResponse = new BaseResponse();
    baseResponse.success = true
    baseResponse.message = 'Password changed successfully!'
    baseResponse.data = {
      email_phone: email_phone,
    }

    return res.status(200).json({ ...baseResponse })
  } catch (error) {
    next(error)
  }
};

//CurrentUser
const currentUser = (req: Request, res: Response, next) => {
  let token = req.headers['authorization'] || req.body.token || req.headers.cookie?.split('=')[1] || req.cookies?.jwt;
  let user;


  if (token) {
    const bearer = token.split(' ');
    if (bearer.length == 2) {
      token = bearer[1];
    } else {
      token = bearer[0];
    }
    let coin: number = 0;
    let userRefferal: number = 0;
    jwt.verify(token, jwtSecret, async (err, decodedToken) => {
      if (err) {
        next(Error("User should be authenticated"))
      } else {
        user = await User.findById(decodedToken.id._id).populate("department", "select _id name")
        .populate("avatar", "select imageAddress -_id")
        .select('-__v -password -createdAt -updatedAt -resetToken')
        .lean().exec();        
        if (!user) {
          next(Error("User should be authenticated"))
        }
        const userStat = await CoinIncentivization.findOne({userId:decodedToken.id._id}).select("-createdAt -updatedAt -_id -__v -userId").lean().exec();
        if (userStat) {
          userStat.coin = (decryptData(userStat.coin,configs.COIN_ENCRIPTION_KEY))
          coin = parseInt(userStat.coin, 10);
          userRefferal = userStat.referralCount;
        }
        let examType = "University Entrance Exam";

        const userCourseAnalysis = await UserCourseAnalysis.find({userId:user._id}).lean().exec();
        let totalChaptersCompleted = 0

        for (const analysis of userCourseAnalysis) {
          totalChaptersCompleted += analysis.completedChapters.length;
        }

        const userChapterAnalysis = await UserChapterAnalysis.find({userId:user._id}).lean().exec();
        let totalSubChaptersCompleted = 0

        for (const analysis of userChapterAnalysis) {
          totalSubChaptersCompleted += analysis.completedSubChapters.length;
        }


        const questionAnswers = await QuestionUserAnswer.find({userId:user._id}).lean().exec();
        const userRankInfo = await leaderboardController.calculateUserRank(user._id);
        const totalStreak = await UserStatistics.findOne({userId: user._id}).lean().exec() || {maxStreak: 0, currentStreak:0, points:0};


        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = "User data retrieved successfully!"
        baseResponse.data = {
          curUser: {...user, ...userRankInfo},
          examType,
          userStats: {
            chaptersCompleted:totalChaptersCompleted,
            topicsCompleted: totalSubChaptersCompleted,
            solvedQuestions: questionAnswers.length,
            coin: coin,
            refferal: userRefferal
          },
          totalStreak,
        }

        return res.status(200).json({ ...baseResponse });
      }
    });
  } else {
    next(Error("User not authenticated!"))
  }
};

const getUserConsistencyData = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const year = parseInt(req.query.year as string) || new Date().getFullYear();

    const userId = req.body.user._id.toString();

    const consistencyData= await getUserconsistency(userId, year)

    let baseResponse = new BaseResponse();
    baseResponse.success = true
    baseResponse.message = "User data retrieved successfully!"
    baseResponse.data = {
      consistencyData,
    }
    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error)
    
  }
}

const updateProfile = async (req: Request, res: Response, next: NextFunction) => {
  try {
      const userId = req.body.user._id.toString();
      const userToBeUpdated = await User.findOne({_id: userId}).lean().exec();

      if (!userToBeUpdated) throw Error("User not found.")

      const { firstName, lastName,department,
        avatar,howPrepared, preferredMethod,
        studyTimePerDay, motivation,
        challengingSubjects, reminder,grade, highSchool, region, gender} = req.body;

      let updateObject = { firstName, lastName,department,
        avatar,howPrepared, preferredMethod,
        studyTimePerDay, motivation,
        challengingSubjects, reminder, grade, highSchool, region, gender}

      for (const key in updateObject){
          if (!updateObject[key]) delete updateObject[key]
      }

      const validatedUser = await updateUserValidation.validateAsync(updateObject);

      const updatedUser = await User.findOneAndUpdate({_id: userId}, validatedUser,{new:true}).populate("department", "select _id name")
      .populate("avatar", "select imageAddress -_id")
      .select('-__v -password -createdAt -updatedAt -resetToken')
      .lean().exec();

      let examType = "University Entrance Exam";

      let baseResponse = new BaseResponse();
      baseResponse.success = true
      baseResponse.message = 'User profile updated successfully!'
      baseResponse.data = {
          updatedUser,
          examType,
      }
      return res.status(200).json({...baseResponse})

  } catch (error) {
      next(error)
  }
}

const userHomePage = async (req, res, next) => {
  try {
    const userId = req.body.user._id.toString();
    const departmentId = req.body.user.department.toString();

    const loggedUser = await logActiveUser(userId, departmentId);

    const userChapterAnalysis = await UserChapterAnalysis.findOne(
      { userId },
      {},
      { sort: { updatedAt: -1 } }
    );

    let lastStartedCourse = null;
    if (userChapterAnalysis) {
      const chapter = await Chapter.findById(userChapterAnalysis.chapterId).populate("courseId", "select _id name");

      if (chapter) {
        lastStartedCourse = chapter;
      }
    }

    const standardMocks = await Mock.aggregate([
      { 
        $match: { 
          departmentId: req.body.user.department, 
          isStandard: true 
        } 
      },
      {
        $addFields: {
          questions: { $size: "$questions" }
        }
      },
      { 
        $project: { 
          name: 1, 
          departmentId: 1, 
          examYear: 1, 
          subject: 1, 
          questions: 1 
        } 
      }
    ]).exec();

    const userMocks = await UserMock.findOne({ userId }).lean().exec();
    const recommendedMocks = [];

    if (userMocks) {
      recommendedMocks.push(
        ...standardMocks.filter((standardMock) => !userMocks.mocks.includes(standardMock._id))
      );
    } else {
      recommendedMocks.push(...standardMocks);
    }

    const examDates = await ExamDate.find().sort({ createdAt: -1 }).lean().exec();

    let baseResponse = {
      success: true,
      message: 'User recommendations fetched successfully!',
      data: {
        lastStartedCourse,
        examDates,
        recommendedMocks,
      },
    };

    return res.status(200).json(baseResponse);
  } catch (error) {
    next(error);
  }
};


const logoutUser = async (req, res, next) => {
  try {
    let baseResponse = new BaseResponse();
    baseResponse.success = true
    baseResponse.message = "User logged out successfully!"
    baseResponse.data = {
      status: "Logged out",
    }
    return res.cookie('jwt', '', { maxAge: 1 }).header('token', "").status(201).json({ ...baseResponse }).end();
  } catch (error) {
    next(Error("Error while logging out!"))
  }
}

// User analytics related controllers
const getUserData = async (req: Request, res: Response, next) => {
  try {
    const {userId}= req.params
  
    const user = await User.findById(userId).populate("department", "select _id name")
    .populate("avatar", "select imageAddress -_id")
    .select('-__v -password -createdAt -updatedAt -resetToken')
    .lean().exec();
    if (!user) {
      throw Error("user not found with this ID.")
    }

    let examType = "University Entrance Exam";

    const userCourseAnalysis = await UserCourseAnalysis.find({userId:user._id}).lean().exec();
    let totalChaptersCompleted = 0

    for (const analysis of userCourseAnalysis) {
      totalChaptersCompleted += analysis.completedChapters.length;
    }

    const userChapterAnalysis = await UserChapterAnalysis.find({userId:user._id}).lean().exec();
    let totalSubChaptersCompleted = 0

    for (const analysis of userChapterAnalysis) {
      totalSubChaptersCompleted += analysis.completedSubChapters.length;
    }
    const questionAnswers = await QuestionUserAnswer.find({userId:user._id}).lean().exec();
    const userRankInfo = await leaderboardController.calculateUserRank(user._id);
    const totalStreak = await UserStatistics.findOne({userId: user._id}).lean().exec() || {maxStreak: 0, currentStreak:0, points:0};


    let baseResponse = new BaseResponse();
    baseResponse.success = true
    baseResponse.message = "User data retrieved successfully!"
    baseResponse.data = {
      curUser: {...user, ...userRankInfo},
      examType,
      userStats: {
        chaptersCompleted:totalChaptersCompleted,
        topicsCompleted: totalSubChaptersCompleted,
        solvedQuestions: questionAnswers.length
      },
      totalStreak,
    }

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error)
  }
};

const getUserConsistencyDataById = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const year = parseInt(req.query.year as string) || new Date().getFullYear();

    const {userId} = req.params

    const consistencyData= await getUserconsistency(userId, year)

    let baseResponse = new BaseResponse();
    baseResponse.success = true
    baseResponse.message = "User data retrieved successfully!"
    baseResponse.data = {
      consistencyData,
    }
    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error)
    
  }
}

const getUserScoreCategory = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const userId  =  req.body.user._id.toString();

    const user = await User.findById(userId).lean().exec();

    if (!user) {
      throw new Error("User not found with this ID.");
    }

    const userStats = await UserStatistics.findOne({ userId }).select('points').lean().exec();

    const userScore = userStats.points;

    const categories = await UserScoreCategory.find().sort({ top: 1 }).lean().exec();

    let userCategory;
    for (const category of categories) {
      if (userScore <= category.start && userScore > category.end) {
        userCategory = category;
        break;
      }
    }
    if (!userCategory) {

      if (userScore > categories[0].start) {
        userCategory = categories[0];
      }
      else if (userScore < categories[categories.length - 1].end) {
        userCategory = categories[categories.length - 1];
      }
      else {
        throw new Error("User score category not found.");
      }
    }

    // Respond with user's category
    const response = {
      success: true,
      message: 'User score category retrieved successfully!',
      data: { 
        userCategory: {...userCategory, userScore},
        categories
      }
    };

    res.status(200).json(response);
  } catch (error) {
    next(error);
  }
}
const getUserCoin = async(req:Request,res: Response,next:NextFunction)=>{
  try{
    const userId = req.body.user._id.toString();
    const user = User.findById(userId).lean().exec();
    if (!user) {
      throw new Error("User not found with this ID.")
    }
    let coin:number = 0
    let refferal:number = 0
    const userStats = await CoinIncentivization.findOne({userId}).select("-createdAt -updatedAt -_id -__v -userId").lean().exec();
    if (userStats) {
      coin = parseInt(decryptData(userStats.coin,configs.COIN_ENCRIPTION_KEY),10)
      refferal = userStats.referralCount
    }
    let baseResponse = new BaseResponse();
    baseResponse.success = true
    baseResponse.message = "User coin retrieved successfully!"
    baseResponse.data = {
      userStats: {
        coin,
        refferal
      }
    }
    return res.status(200).json({ ...baseResponse });
  }catch(error){
    next(error)
  }
}
    

const UserControllers = { 
                          userLogin, userSignup, 
                          logoutUser, changePassword, 
                          sendOtpVerification, resendOtpVerification, 
                          forgotChangePassword, userForgotPassVerifyOTP, getUserData, getUserConsistencyDataById,
                          currentUser, updateProfile, userHomePage, forgotPassSendOtpVerification, getUserConsistencyData,getUserScoreCategory,
                          getUserCoin
                        }
export default UserControllers