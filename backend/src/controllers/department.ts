import { Request, Response, NextFunction } from 'express';
import Department from '../models/department';
import { departmentValidator } from '../validations/joiModelValidator';
import { BaseResponse } from '../types/baseResponse';

const createDepartment = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const {
            description, name,
            noOfCourses
        } = req.body;

        const userInput = { description, name, noOfCourses }

        const { error, value } = departmentValidator(userInput,"post");

        if (error) throw error

        const department = new Department({...value});

        const savedDepartment = await department.save();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Department created successfully!'
        baseResponse.data = {
        newDepartment: savedDepartment
        }

        return res.status(201).json({...baseResponse})
    } catch (error) {
        next(error)
    };
}

const getDepartments = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const departments = await Department.find().lean().exec();
        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Departments retrieved successfully!'
        baseResponse.data = {
        departments,
        }

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error)
    }
}

const getDepartment = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const id = req.params.id;
        const department = await Department.findOne({_id:id}).lean().exec();

        if (!department) throw Error("Department not found with that Id.")

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Department retrieved successfully!'
        baseResponse.data = {
        department,
        }

        return res.status(200).json({...baseResponse});

    } catch (error) {
        next(error)
    }
}

const updateDepartment = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const departmentToBeUpdated = await Department.findById(id).lean().exec();

        if (!departmentToBeUpdated) throw Error("Department not found with that Id.")

        const {
            description, name,
            noOfCourses
        } = req.body;

        let updateObject = { description, name, noOfCourses }

        for (const key in updateObject){
            if (!updateObject[key]) delete updateObject[key]
        }

        const { error, value } = departmentValidator(updateObject,"put");

        if (error) throw error;

        const updatedDepartment = await Department.findByIdAndUpdate(id, value, {new: true}).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Department updated successfully!'
        baseResponse.data = {
            updatedDepartment,
        }
        return res.status(200).json({...baseResponse})

    } catch (error) {
        next(error)
    }
}

const deleteDepartment = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const departmentToBeDeleted = await Department.findById(id).lean().exec();

        if (!departmentToBeDeleted) throw Error("Department not found with that Id.");

        const deletedDepartment = await Department.findByIdAndDelete(id).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Department deleted successfully!'
        baseResponse.data = {
            deletedDepartment,
        }

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error)
    }
}

const departmentControllers = {createDepartment, getDepartments, getDepartment, updateDepartment, deleteDepartment}

export default departmentControllers