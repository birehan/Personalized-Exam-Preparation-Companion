import { Request, Response, NextFunction } from 'express';
import {  UserRole } from '../../models/dashboardUser';

// Middleware for checking if the user is a REVIEWER
export const isReviewer = (req: Request, res: Response, next: NextFunction) => {
    const { dashboardUser } = req.body;
  
    if (dashboardUser && dashboardUser.role === UserRole.REVIEWER) {
      next();
    } else {
      return res.status(403).json({ error: { msg: 'Forbidden. User is not a REVIEWER.' } });
    }
  };