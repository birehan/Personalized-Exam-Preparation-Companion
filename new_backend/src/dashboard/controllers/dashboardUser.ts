import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcrypt';
import nodemailer from 'nodemailer';

import DashboardUser, { IDashboardUserDocument, dashboardUserValidation, UserRole } from '../models/dashboardUser';
import { BaseResponse } from '../../types/baseResponse';
import configs from '../../config/configs';
import QuestionUserAnswer from '../../models/questionUserAnswer';
import { adminValidator, reviewerAdminValidator, reviwerValidator } from '../../validations/joiModelValidator';
import Reviewer, {IReviewer} from '../models/reviewer';
import Admin, { IAdmin } from '../models/admin';
import ReviewerAdmin, { IReviewerAdmin } from '../models/reviewerAdmin';


const jwtSecret = configs.JWT_SECRET;

const maxAge = configs.AUTH_TOKEN_EXP_DAY * 24 * 60 * 60;
export const createToken = (id) => {
  return jwt.sign({ id }, jwtSecret, {
    expiresIn: maxAge,
  });
};

const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: configs.EMAIL,
      pass: configs.PASSWORD,
    }
  })

const dashboardUserLogin = async (req: Request, res: Response, next: NextFunction) => {
  try {
    let { email_phone, password } = req.body;
    email_phone = email_phone.trim();
    password = password.trim();

    let baseResponse = new BaseResponse();

    if (email_phone === null || password === null || email_phone === '' || password === '') {
      throw Error('Must provide Email/Phone_Number and password.');
    }

    const dashBoardUser = await DashboardUser.login(email_phone, password);

    const token = createToken(dashBoardUser);

    res.header('token', token);
    res.cookie('jwt', token, { httpOnly: true, maxAge: maxAge * 1000 });

    const curDashBoardUser = await DashboardUser.findOne({ _id: dashBoardUser._id })
      .select('-__v -password -createdAt -updatedAt')
      .lean()
      .exec();

    baseResponse.success = true;
    baseResponse.message = 'User logged in successfully';
    baseResponse.data = {
      token: token,
      curDashBoardUser: curDashBoardUser,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (err) {
    next(err);
  }
};

const sendCredentialsEmail = async ({ email, password }) => {
    email.trim();

    if (email == "" || !email) {
        throw Error("Empty email is not allowed.");
    }

    const mailOptions = {
        from: configs.EMAIL,
        to: email,
        subject: "SkillBridge Dashboard Account Credentials",
        html: `Your email: ${email}<br> Your password: ${password}`
    };

    const result = await transporter.sendMail(mailOptions);
};
  
const createSuperAdmin = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const existingSuperAdmin = await DashboardUser.findOne({ role: 'SUPER_ADMIN' }).lean().exec();

      if (existingSuperAdmin) {
      // Super admin already created
      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Super Admin already created.';
      return res.status(200).json({ ...baseResponse });
      }

      // Generate a random password for the super admin
      const password = Math.random().toString(36).slice(2);

      // Create a new super admin
      const superAdminData = {
          email_phone: 'daniel.tefera@a2sv.org',
          password: password,
          role: UserRole.SUPER_ADMIN,
          isActive: true,
          createdAt: new Date(),
          updatedAt: new Date(),
      };

      const superAdmin = new DashboardUser(superAdminData);
      await superAdmin.save();

      const adminDetail = new Admin({userId:superAdmin._id, firstName:"Daniel", lastName:"Tefera"});
      await adminDetail.save();

      // Send the super admin credentials via email
      await sendCredentialsEmail({ email: superAdminData.email_phone, password });

      // Create a JWT token for the super admin
      const token = createToken(superAdmin);

      res.header('token', token);
      res.cookie('jwt', token, { httpOnly: true, maxAge: maxAge * 1000 });

      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Super Admin created successfully. Credentials sent via email.';

      return res.status(201).json({ ...baseResponse });

    } catch (err) {
        next(err);
    }
};

export const createAdmin = async (user, firstName, lastName) => {
  try {
    let userId = user.toString()
    const {error, value} = adminValidator({userId, firstName, lastName}, 'post');
    if (error) {
      throw error
    }

    const newAdmin = await Admin.create({
      userId,
      firstName,
      lastName,
    } as IAdmin);
    return {name: firstName + " " + lastName}

  } catch (error) {
    if(user){
      await DashboardUser.findOneAndDelete(user)
    }
    throw error
  }
};

export const createReviewerAdmin = async (user, firstName, lastName) => {
  try {
    let userId = user.toString()
    const {error, value} = reviewerAdminValidator({userId, firstName, lastName}, 'post');
    if (error) {
      throw error
    }

    const newReviewerAdmin = await ReviewerAdmin.create({
      userId,
      firstName,
      lastName,
    } as IReviewerAdmin);
    return {name: firstName + " " + lastName}

  } catch (error) {
    if(user){
      await DashboardUser.findOneAndDelete(user)
    }
    throw error
  }
};

const createReviewer = async (user, firstName, lastName, subject)=>{
  try{
    let userId= user.toString()
    const reviwerUser= {userId, firstName, lastName, subject}
  
    const {error, value} = reviwerValidator({...reviwerUser}, 'post');
  
    if (error) throw error
  
    const existingReviewer = await Reviewer.findOne({ userId }).lean().exec();
    if (existingReviewer) throw Error('Existing Reviwer')
  
    const newReviewer = await Reviewer.create({
      userId,
      firstName,
      lastName,
      subject,
    } as IReviewer);
    return {name: newReviewer.firstName + " " + newReviewer.lastName, subject: newReviewer.subject}
  }catch(error){
    if(user){
      await DashboardUser.findOneAndDelete(user)
    }
    throw error
  }
}

const createDashboardUser = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const {  firstName, lastName, subject, email_phone, role } = req.body
    const password = Math.random().toString(36).slice(2);

    const dashboardUser= {
      email_phone,
      password,
      role
    }

    let {error, value} = dashboardUserValidation.validate(dashboardUser)

    if (error) throw error

    const foundUser = await DashboardUser.findOne({email_phone,}).lean().exec()

    if (foundUser){
      throw Error("That email is already registered!")
    }

    const  user = new DashboardUser(dashboardUser);
    const savedUser = await user.save();
    // Send the super admin credentials via email
    await sendCredentialsEmail({ email: dashboardUser.email_phone, password });


    const userId= savedUser._id

    let response
    if(role === 'ADMIN'){
      response = await createAdmin(userId, firstName, lastName)
      
    }else if ( role === 'REVIEWER_ADMIN'){
      response = await createReviewerAdmin(userId, firstName, lastName)
    }else if ( role === 'REVIEWER'){
      response = await createReviewer(userId, firstName, lastName, subject)
    }else{
      throw Error('Undefined user!!')
    }

    const baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'User created successfully';
    baseResponse.data = {...response, email_phone: savedUser.email_phone, role: savedUser.role};

    return res.status(201).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getDashboardUsers = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const aggregatePipeline = [
      {
        $lookup: {
          from: "dashboardusers",
          localField: "userId",
          foreignField: "_id",
          as: "userDetails"
        }
      },
      {
        $unwind: "$userDetails"
      },
      {
        $project: {
          _id: 1,
          userId: 1,
          firstName: 1,
          lastName: 1,
          subject: 1,
          isActive: "$userDetails.isActive",
          email_phone: "$userDetails.email_phone",
          role: "$userDetails.role",
          name: { $concat: ["$firstName", " ", "$lastName"] }
        }
      },
      {
        $match: {
          "role": { $ne: "SUPER_ADMIN" }
        }
      }
    ]

    const users = await Promise.all([
      Reviewer.aggregate(aggregatePipeline).exec(),
      Admin.aggregate(aggregatePipeline).exec()
    ]);

    const baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Reviewers retrieved successfully';
    baseResponse.data = users.flat(); 

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const updateAdmin = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const {error, value} = adminValidator(req.body, 'put');
    if (error) {
      throw error
    }

    const updatedAdmin = await Admin.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!updatedAdmin) {
      throw Error('User not foud')
    }
    const baseResponse = new BaseResponse();
    
    baseResponse.success = true;
    baseResponse.message = 'Admin updated successfully';
    baseResponse.data = updatedAdmin;

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error)
  }
}

const toggleDashboardUserStatus = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;

    
    const user: IDashboardUserDocument | null = await DashboardUser.findById(id);

    if (!user) {
      const baseResponse = new BaseResponse();
      baseResponse.success = false;
      baseResponse.message = 'User not found!';
      return res.status(404).json({ ...baseResponse });
    }

   
    user.isActive = !user.isActive;

    await user.save();

    const baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'User status toggled successfully!';
    baseResponse.data = { isActive: user.isActive };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const changePassword = async (req: Request, res: Response, next) => {
  const { oldPassword, newPassword, confirmPassword } = req.body
  try {
    oldPassword.trim()
    newPassword.trim()
    confirmPassword.trim()


    if (!oldPassword || !newPassword || !confirmPassword || oldPassword == "" || newPassword == "" || confirmPassword == "") {
      throw Error("Empty fields are not allowed")
    }

    if (newPassword !== confirmPassword) {
      throw Error("Wrong password confirmation!")
    }
    
    if (newPassword.length < 6) {
      throw Error("Password length should be greater than 6!")
    }

    const userInfo = await DashboardUser.findOne({_id: req.body.dashboardUser._id}).lean().exec()
    
    const isValid = await bcrypt.compare(oldPassword, userInfo.password);
    if (!isValid) {
      throw Error("Wrong Old password!")
    }
    
    const salt = await bcrypt.genSalt();
    const hashedPassword = await bcrypt.hash(newPassword, salt);

    const changedUser = await DashboardUser.findOneAndUpdate(
      { _id: userInfo._id },
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

const currentDashboardUser = (req: Request, res: Response, next) => {
      try {
        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = "User data retrieved successfully!"
        baseResponse.data = {
          userDetails:{
            ...req.body.dashboardUser,
            ...req.body.userDetails
          }
        }

        return res.status(200).json({ ...baseResponse });
      } catch (error) {
        next(error)
      }
};

const dashboardUserController = { dashboardUserLogin, createSuperAdmin, createDashboardUser, getDashboardUsers, updateAdmin, toggleDashboardUserStatus, changePassword, currentDashboardUser }

export default dashboardUserController
