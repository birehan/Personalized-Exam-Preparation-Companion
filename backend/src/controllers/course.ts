import { Request, Response, NextFunction } from 'express';
import Course from '../models/course';
import { courseValidator } from '../validations/joiModelValidator';
import { BaseResponse } from '../types/baseResponse';
import Department from '../models/department';
import { Schema, Types } from 'mongoose';
import Chapter from '../models/chapter';
import SubChapter from '../models/subChapter';
import { logActiveUser } from '../services/helpers';

const createCourse = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const {
            description, name,
            noOfChapters, image, departmentId
        } = req.body;
        var depId =new Types.ObjectId(departmentId);
     
        const userInput = { description, name,  noOfChapters,image,departmentId}

        const { error, value } = courseValidator(userInput,"post");
    
        if (error) throw error

        const foundDepartment = await Department.findOne({"_id": depId})
        if (!foundDepartment) throw Error("Department Id does not exist")

        const course = new Course({...value});
      
        const savedCourse = await course.save();

        const {noOfCourses} = await Department.findOne({"_id": depId})
        const newNoOfCourse:number = Number( noOfCourses)+ 1
        await Department.findByIdAndUpdate(depId, {noOfCourses: newNoOfCourse}).lean().exec();
        
        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Course created successfully!'
        baseResponse.data = {
        newCourse: savedCourse
        }

        return res.status(201).json({...baseResponse})
    } catch (error) {
        next(error)
    };
}

const getCourses = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const courses = await Course.find().lean().exec();
  
      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Courses retrieved successfully!';
      baseResponse.data = {
        courses: courses,
      };
  
      return res.status(200).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };
  

const getCoursesByDepartment = async (req: Request, res: Response, next: NextFunction) => {
try {
    let id = req.params.departmentId;

    console.log("id: " + id);
    let foundDepartment = null;
    const departments = await Department.find().lean().exec();

    for (let i=0; i < departments.length; i++){
        if (departments[i]["_id"].toString() == id){
            foundDepartment = departments[i]
        }
    }



    
    // const foundDepartment = await Department.findOne({"_id": id}).lean().exec();

    if (!foundDepartment) throw Error("No Department by this Id. hi");

    const departmentId= new Types.ObjectId(id)
    const specificDepartmentId = new Types.ObjectId("65898c5b52f4ffeace9210e6");

    let excludedCourses = [];

    if (id === "64c24e0e85876fbb3f8dd6ca") {
    excludedCourses = ["Biology", "Chemistry", "Physics"];
    } else if (id === "64c24df185876fbb3f8dd6c7") {
    excludedCourses = ["History", "Geography"];
    }

    const courses = await Course.find().lean().exec();

    let courseCatalog = {
        Biology: [],
        Chemistry: [],
        Civics: [],
        English: [],
        Mathematics: [],
        Physics: [],
        SAT: [],
        Economics: [],
        History: [],
        Business: [],
        Geography: [],
        Others: []
    };

    courseCatalog["Biology"] = courses


    let baseResponse = new BaseResponse();
    baseResponse.success = true
    baseResponse.message = 'Courses retrieved successfully!'
    baseResponse.data = {
        departmentCourses: courseCatalog,
    }

    return res.status(200).json({...baseResponse});

} catch (error) {
    next(error)
}
}

const getCourse = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const id = req.params.id;

        const course = await Course.findOne({_id:id}).populate("image", "select imageAddress -_id").lean().exec();

        if (!course) throw Error("Course not found with that Id.")

        
        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Course retrieved successfully!'
        baseResponse.data = {
           course,
        }

        return res.status(200).json({...baseResponse});

    } catch (error) {
        next(error)
    }
}

const updateCourse = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const courseToBeUpdated = await Course.findOne({"_id": id}).lean().exec();

        if (!courseToBeUpdated) throw Error("Course not found with that Id.")

        const {
            description, name,
             noOfChapters,image, departmentId,
        } = req.body;

        let updateObject = { description, name,  noOfChapters,image, departmentId}

        for (const key in updateObject){
            if (!updateObject[key]) delete updateObject[key]
        }
        let foundDepartment
        
        if (departmentId){
            foundDepartment  = await Department.findOne({"_id": id})
            if (!foundDepartment) throw Error("Department Id does not exist")
        }
        const { error, value } = courseValidator(updateObject,"put");

        if (error) throw error;

        const updatedCourse = await Course.findByIdAndUpdate(id, value,{new:true}).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Course updated successfully!'
        baseResponse.data = {
            updatedCourse,
        }
        return res.status(200).json({...baseResponse})

    } catch (error) {
        next(error)
    }
}

const deleteCourse = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const courseToBeDeleted = await Course.findOne({"_id": id}).lean().exec();

        if (!courseToBeDeleted) throw Error("Course not found with that Id.");

        const deletedCourse = await Course.findByIdAndDelete(id).lean().exec();
        const {departmentId} = deletedCourse
        const department = await Department.findOne({"_id": departmentId}).lean().exec();

        await Department.findByIdAndUpdate(departmentId, {noOfCourses: Number(department.noOfCourses) - 1},{new:true}).lean().exec();
    
        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'Course deleted successfully!'
        baseResponse.data = {
            deletedCourse,
        }

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error)
    }
}



const courseControllers = {createCourse, getCourses, getCourse, updateCourse, deleteCourse, getCoursesByDepartment}

export default courseControllers