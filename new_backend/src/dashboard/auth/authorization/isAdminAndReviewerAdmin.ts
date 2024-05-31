import { Request, Response, NextFunction } from 'express';
import { UserRole } from '../../models/dashboardUser';

  // Middleware for checking if the user is an ADMIN or REVIEWER_ADMIN
  export const isAdminOrReviewerAdmin = (req: Request, res: Response, next: NextFunction) => {
    const { dashboardUser } = req.body;
  
    if (dashboardUser && (dashboardUser.role === UserRole.SUPER_ADMIN || dashboardUser.role === UserRole.ADMIN || dashboardUser.role === UserRole.REVIEWER_ADMIN)) {
      next();
    } else {
      return res.status(403).json({ error: { msg: 'Forbidden. User is not an Authorized.' } });
    }
  };