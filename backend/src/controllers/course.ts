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
      const courses = await Department.find().lean().exec();
  
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
        
        const foundDepartment = await Department.findOne({"_id": id}).lean().exec();

        if (!foundDepartment) throw Error("No Department by this Id.");

        const departmentId= new Types.ObjectId(id)
        const specificDepartmentId = new Types.ObjectId("65898c5b52f4ffeace9210e6");

        let excludedCourses = [];

        if (id === "64c24e0e85876fbb3f8dd6ca") {
        excludedCourses = ["Biology", "Chemistry", "Physics"];
        } else if (id === "64c24df185876fbb3f8dd6c7") {
        excludedCourses = ["History", "Geography"];
        }

        const departmentCourses = await Course.aggregate([
        {
            $match: {
            $or: [
                { departmentId: { $eq: departmentId } },
                { departmentId: { $eq: specificDepartmentId } }
            ],
            name: { $nin: excludedCourses }
            }
        },
        {
            $lookup: {
              from: 'images',
              localField: 'image',
              foreignField: '_id',
              as: 'image',
            },
          },
          {
            $set: {
              image: {
                $ifNull: [{ $arrayElemAt: ['$image.imageAddress', 0] }, null],
              },
            },
          },
        {
            $project: {
            name: 1,
            image: {
                $cond: {
                  if: { $eq: ['$image', null] },
                  then: null,
                  else: { imageAddress: '$image' },
                },
            },
            description: 1,
            noOfChapters: 1,
            grade: 1,
            departmentId: 1,
            referenceBook: 1,
            ECTS: 1,
            curriculum: 1
            }
        }
        ]).exec();


        if (foundDepartment.name !== 'Natural Science' && foundDepartment.name !== 'Social Science' && foundDepartment.name !== 'grade 9 and 10') {
            let baseResponse = new BaseResponse();
            baseResponse.success = true;
            baseResponse.message = 'Courses retrieved successfully!';
            baseResponse.data = {
                departmentCourses
            };
            return res.status(200).json({ ...baseResponse });
        }

        const courseCatalog = {
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

        departmentCourses.forEach(course => {
            let mapped = false;

            for (const category in courseCatalog) {
                if (category !== 'Others' && course.name.includes(category)) {
                    courseCatalog[category].push(course);
                    mapped = true;
                    break;
                }
            }

            if (!mapped) {
                courseCatalog.Others.push(course);
            }
        });

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