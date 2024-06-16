import { Request, Response, NextFunction } from 'express';
import { UserRole } from '../../models/dashboardUser';

  // Middleware for checking if the user is an ADMIN
  export const isAdmin = (req: Request, res: Response, next: NextFunction) => {
    const { dashboardUser } = req.body;
  
    if (dashboardUser && (dashboardUser.role === UserRole.SUPER_ADMIN || dashboardUser.role === UserRole.ADMIN)) {
      next();
    } else {
      return res.status(403).json({ error: { msg: 'Forbidden. User is not an ADMIN.' } });
    }
  };