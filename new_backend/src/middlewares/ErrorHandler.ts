import { NextFunction, Request, Response } from "express";
import { BaseResponse } from "../types/baseResponse";
// handle error
export default function errorHandler(err: any, req: Request, res: Response, next: NextFunction) {

	if (res.headersSent) {
		return next()
	}
	let baseResponse = new BaseResponse();
    baseResponse.message = err.message
    baseResponse.errors.push(err.message)
	res.status(500).json({...baseResponse})
	return
}