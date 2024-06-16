import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import DashboardUser, { IDashboardUserDocument, UserRole } from '../../models/dashboardUser';
import Admin, { IAdmin } from '../../models/admin'
import Reviewer, { IReviewer } from '../../models/reviewer';
import dotenv from 'dotenv';
import ReviewerAdmin from '../../models/reviewerAdmin';

dotenv.config();
const jwtSecret = process.env.JWT_SECRET;

const dashboardAuthenticator = async (req: Request, res: Response, next: NextFunction) => {
  let token = req.headers['authorization'] || req.body.token || req.headers.cookie?.split('=')[1] || req.cookies?.jwt;

  if (token) {
    const bearer = token.split(' ');
    if (bearer.length == 2) {
      token = bearer[1];
    } else {
      token = bearer[0];
    }
    jwt.verify(token, jwtSecret, async (err, decodedToken) => {
      if (err) {
        return res
          .status(400).json({ error: { msg: 'User not authenticated. The token sent is bad or expired.' } }).end();
      } else {
        const dashboardUser = await DashboardUser.findById(decodedToken.id._id).select('-password -createdAt -updatedAt -__v').lean().exec();
        if (!dashboardUser) {
          return res.status(400).json({ error: { msg: 'User not authenticated or token sent is bad or expired.' } }).end();
        }

        req.body.dashboardUser = dashboardUser;

        try {
          let userDetails;

          if (dashboardUser.role === UserRole.SUPER_ADMIN || dashboardUser.role === UserRole.ADMIN) {
            userDetails = await Admin.findOne({ userId: dashboardUser._id }).populate({ path: 'avatar', select: '-_id imageAddress',}).lean().exec();
          } else if (dashboardUser.role === UserRole.REVIEWER_ADMIN) {
            userDetails = await ReviewerAdmin.findOne({ userId: dashboardUser._id }).populate({ path: 'avatar', select: '-_id imageAddress',}).lean().exec();
          } else if (dashboardUser.role === UserRole.REVIEWER) {
            userDetails = await Reviewer.findOne({ userId: dashboardUser._id }).populate({ path: 'avatar', select: '-_id imageAddress',}).lean().exec();
          }

          if (userDetails) {
            req.body.userDetails = userDetails;
          }
        } catch (error) {
          throw Error(`Error fetching user details: ${error}`);
        }

        next();
      }
    });
  } else {
    return res.status(400).json({ error: { msg: 'User not authenticated!' } }).end();
  }
};

export default dashboardAuthenticator;
