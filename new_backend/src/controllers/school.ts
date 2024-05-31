import { Request, Response, NextFunction } from "express";
import { schoolValidationSchema } from "../validations/joiModelValidator";
import School from "../models/school";
import { BaseResponse } from "../types/baseResponse";
import Department from "../models/department";
import { RegionEnum } from "../types/typeEnum";


const createSchool = async (req: Request, res: Response,next: NextFunction) => {
  try {
    const { name, region } = req.body;

    const { error, value } = schoolValidationSchema.validate({
      name,
      region,
    });

    if (error) {
      throw error;
    }

    const newSchool = new School({
      name,
      region,
    });

    const savedSchool = await newSchool.save();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = "School created successfully!";
    baseResponse.data = savedSchool

    res.status(201).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getAllSchools = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const schools = await School.find().lean().exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = "Schools retrieved successfully!";
    baseResponse.data = schools

    res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getSchoolById = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const schoolId = req.params.id;

    const school = await School.findById(schoolId).lean().exec();

    if (!school) {
      throw Error('School not found ')
    }

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = "School retrieved successfully!";
    baseResponse.data = school

    res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const updateSchoolById = async (req: Request, res: Response, next: NextFunction
) => {
  try {
    const schoolId = req.params.id;
    const { name, region } = req.body;
    
    const updatedSchool = await School.findByIdAndUpdate(
      schoolId,
      { name, region },
      { new: true }
    ).lean().exec();

    if (!updatedSchool) {
      throw Error("School not found!")
    }

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = "School updated successfully!";
    baseResponse.data = {
      updatedSchool,
    };

    res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const deleteSchoolById = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const schoolId = req.params.id;

    const deletedSchool = await School.findByIdAndDelete(schoolId).lean().exec();

    if (!deletedSchool) {
      throw Error('School not found')
    }

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = "School deleted successfully!";
    baseResponse.data = {
      deletedSchool,
    };

    res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

export const getSchoolsAndDepartments = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const schools = await School.find({}, { _id: 1, name: 1, region: 1 })
      .lean()
      .exec();

    const departments = await Department.find({}, { _id: 1, name: 1 })
      .lean()
      .exec();

    const regions = Object.values(RegionEnum);



    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = "Schools and departments fetched successfully!";
    baseResponse.data = {
      schools,
      departments,
      regions
    };

    res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};
const schoolControllers = {getSchoolsAndDepartments, createSchool, getAllSchools, getSchoolById, updateSchoolById, deleteSchoolById}

export default schoolControllers