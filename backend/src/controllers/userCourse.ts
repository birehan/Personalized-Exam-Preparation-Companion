import { Request, Response, NextFunction } from 'express';
import UserCourse from '../models/userCourse';
import { userCourseValidator } from '../validations/joiModelValidator';
import { BaseResponse } from '../types/baseResponse';
import User from '../models/user';
import Course from '../models/course';

const createUserCourse = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const userId = req.body.user._id.toString();
        const { courses } = req.body;

        const userInput = { userId, courses}

        const { error, value } = userCourseValidator(userInput,"post");

        if (error) throw error

        const userCourse = new UserCourse({...value});

        const savedUserCourse = await userCourse.save();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'UserCourse created successfully!'
        baseResponse.data = {
        newUserCourse: savedUserCourse
        }

        return res.status(201).json({...baseResponse})
    } catch (error) {
        next(error)
    };
}

const getUserCourses = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const userId = req.body.user._id.toString();
  
      const userCourse = await UserCourse.findOne({ userId }).populate({ path: 'courses', populate: { path: 'image', select: 'imageAddress -_id' }}).lean().exec();
      
      let baseResponse = new BaseResponse();
      if (!userCourse) {
        baseResponse.success = true;
        baseResponse.message = 'UserCourses retrieved successfully!';
        baseResponse.data = {
            userCourses: []
        };
        return res.status(200).json({ ...baseResponse });
    }
 
    } catch (error) {
      next(error);
    }
  };

const getUserCourse = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const id = req.params.id;
        const userCourse = await UserCourse.findOne({_id:id}).lean().exec();

        if (!userCourse) throw Error("UserCourse not found with that Id.")

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'UserCourse retrieved successfully!'
        baseResponse.data = {
        userCourse,
        }

        return res.status(200).json({...baseResponse});

    } catch (error) {
        next(error)
    }
}


const deleteUserCourse = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const userCourseToBeDeleted = await UserCourse.findById(id).lean().exec();

        if (!userCourseToBeDeleted) throw Error("UserCourse not found with that Id.");

        const deletedUserCourse = await UserCourse.findByIdAndDelete(id).lean().exec();

        let baseResponse = new BaseResponse();
        baseResponse.success = true
        baseResponse.message = 'UserCourse deleted successfully!'
        baseResponse.data = {
            deletedUserCourse,
        }

        return res.status(200).json({...baseResponse});
    } catch (error) {
        next(error)
    }
}
const addCourseToUserCourses = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { user, course } = req.body;
      const foundCourse = await Course.findById(course);
      if (!foundCourse) {
        throw new Error("Course does not exist");
      }
  
      let userCourseToBeUpdated = await UserCourse.findOne({ userId: user._id });
  
      if (!userCourseToBeUpdated) {
        userCourseToBeUpdated = new UserCourse({
          userId: user._id,
          courses: [course],
        });
        await userCourseToBeUpdated.save();
      } else {
        const courseExists = userCourseToBeUpdated.courses.includes(course);
        if (!courseExists) {
          userCourseToBeUpdated.courses.push(course);
          await userCourseToBeUpdated.save();
        }
      }

      const baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = "Course added to user courses successfully!";
      baseResponse.data = {
        userCourseToBeUpdated,
      };
  
      return res.status(200).json({ ...baseResponse });
    } catch (error) {
      next(error);
    }
  };
  const removeCourseFromUserCourses = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { course, user } = req.body;
  
      const foundUserCourse = await UserCourse.findOne({ userId: user._id.toString() });
      if (!foundUserCourse) {
        throw new Error("User course does not exist.");
      } else if (!foundUserCourse.courses.includes(course)) {
        throw new Error("Course does not exist in the user courses provided.");
      } else {
        const userCourseToBeUpdated = await UserCourse.findOneAndUpdate(
          { userId: user._id.toString() },
          { $pull: { courses: course } },
          { new: true }
        ).lean().exec();
  
        const baseResponse = new BaseResponse();
        baseResponse.success = true;
        baseResponse.message = 'Course removed from user successfully!';
        baseResponse.data = {
          userCourseToBeUpdated,
        };
  
        return res.status(200).json({ ...baseResponse });
      }
    } catch (error) {
      next(error);
    }
  };

const UserCourseControllers = {createUserCourse, getUserCourses, getUserCourse, deleteUserCourse, addCourseToUserCourses, removeCourseFromUserCourses}

export default UserCourseControllers