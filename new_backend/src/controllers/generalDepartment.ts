import { Request, Response, NextFunction } from 'express';
import GeneralDepartment from '../models/generalDepartment';
import { generalDepartmentValidator } from '../validations/joiModelValidator';
import { BaseResponse } from '../types/baseResponse';
import Department from '../models/department';

const createGeneralDepartment = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const {
            description, name, isForListing
        } = req.body;

        const userInput = { description, name, isForListing}

        const { error, value } = generalDepartmentValidator(userInput,"post");

        if (error) throw error

        const generalDepartment = new GeneralDepartment({...value});

        const savedGeneralDepartment = await generalDepartment.save();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'GeneralDepartment created successfully!'
        baseResponse.data = {
        newGeneralDepartment: savedGeneralDepartment
        }

        return res.status(201).json({...baseResponse})
    } catch (error) {
        next(error)
    };
}

const getGeneralDepartments = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const generalDepartments = await GeneralDepartment.find().lean().exec();
       
        const departmentPromise = generalDepartments.map(async (generalDepartment:any) => {
            const departments = await Department.find({generalDepartmentId: generalDepartment._id}).lean().exec()  
            return departments || [];
        });

        const departments = await Promise.all(departmentPromise)
      const generalDepartmentsWithDepartment  = generalDepartments.map((generalDepartment: any, index: number) => {
        const department = departments[index];
        return {
          _id: generalDepartment._id,
          name: generalDepartment.name,
          isForListing: generalDepartment.isForListing,
          description: generalDepartment.description,
          departments: department || [],
        };
      });
  

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'GeneralDepartments retrieved successfully!'
        baseResponse.data = {
            generalDepartments: generalDepartmentsWithDepartment
        }

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error)
    }
}

const getGeneralDepartment = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const id = req.params.id;
        const generalDepartment = await GeneralDepartment.findOne({_id:id}).lean().exec();

        if (!generalDepartment) throw Error("GeneralDepartment not found with that Id.")

        const departments = await Department.find({generalDepartmentId: generalDepartment._id})

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'GeneralDepartment retrieved successfully!'
        baseResponse.data = {
        generalDepartment,
        departments
        }

        return res.status(200).json({...baseResponse});

    } catch (error) {
        next(error)
    }
}

const updateGeneralDepartment = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const generalDepartmentToBeUpdated = await GeneralDepartment.findById(id).lean().exec();

        if (!generalDepartmentToBeUpdated) throw Error("GeneralDepartment not found with that Id.")

        const {
            description, name, isForListing
        } = req.body;

        let updateObject = { description, name, isForListing}

        for (const key in updateObject){
            if (!updateObject[key]) delete updateObject[key]
        }

        const { error, value } = generalDepartmentValidator(updateObject,"put");

        if (error) throw error;

        const updatedGeneralDepartment = await GeneralDepartment.findByIdAndUpdate(id, value, {new: true}).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'GeneralDepartment updated successfully!'
        baseResponse.data = {
            updatedGeneralDepartment,
        }
        return res.status(200).json({...baseResponse})

    } catch (error) {
        next(error)
    }
}

const deleteGeneralDepartment = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const generalDepartmentToBeDeleted = await GeneralDepartment.findById(id).lean().exec();

        if (!generalDepartmentToBeDeleted) throw Error("GeneralDepartment not found with that Id.");

        const deletedGeneralDepartment = await GeneralDepartment.findByIdAndDelete(id).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'GeneralDepartment deleted successfully!'
        baseResponse.data = {
            deletedGeneralDepartment,
        }

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error)
    }
}

const GeneralDepartmentControllers = {createGeneralDepartment, getGeneralDepartments, getGeneralDepartment, updateGeneralDepartment, deleteGeneralDepartment}

export default GeneralDepartmentControllers
