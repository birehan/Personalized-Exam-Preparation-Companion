import express, { Request, Response, NextFunction } from 'express';
import { RateLimiterMemory } from 'rate-limiter-flexible';
import { BaseResponse } from '../types/baseResponse';
import dotenv from 'dotenv';

dotenv.config()

const rateLimiter = new RateLimiterMemory({
  points: parseInt(process.env.RATE_LIMITER_POINTS) || 10, // maximum number of requests allowed
  duration: parseInt(process.env.RATE_LIMITER_DURATION) || 10, // time frame in seconds
});

export const rateLimiterMiddleware = (req: Request, res: Response, next: NextFunction) => {
    rateLimiter.consume(req.ip)
      .then(() => {
        next();
      })
      .catch(() => {
        const baseResponse = new BaseResponse();
        baseResponse.success = false;
        baseResponse.message = 'Too Many Requests, Please try again later!';
        baseResponse.data = null;
        return res.status(429).json(baseResponse);
      });
  };
  