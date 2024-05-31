import { NextFunction, Request, Response } from "express";
import Course from "../../models/course";
import { BaseResponse } from './../../types/baseResponse';
import Mock, { IMock } from "../../models/mock";
import { isValidObjectId } from "../../services/helpers";
import { ObjectId } from "mongodb";
import ContentFlag, { IContentFlag } from "../../models/contentFlag";
import QuestionFlag, { IQuestionFlag } from "../../models/questionFlag";
import Chapter from '../../models/chapter';
import SubChapterContent from '../../models/subChapterContent';
import SubChapter from "../../models/subChapter";
import { Subject } from "../../types/typeEnum";
import { categorizeCourse } from "../../services/helpers";
import Reviewer from "../models/reviewer";
import SubChapterReview from "../models/subChapterReview";
import { chapterValidator } from "../../validations/joiModelValidator";
import Department from "../../models/department";
import { match } from "assert";
import configs from "../../config/configs";
import { Types } from "mongoose";
import Image from "../../models/image";

const getCourses = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { departmentId, grade } = req.query;
    let matchingCondition: any = {};

    if (departmentId) {
      if (!isValidObjectId(departmentId.toString())) {
        throw new Error('Invalid departmentId!');
      }
      
      const departmentObjectId = new Types.ObjectId(departmentId.toString());

      let excludedCourses: string[] = [];
      switch (departmentId) {
        case configs.SOCIAL_SCIENCE_DEPARTMENT_ID:
          excludedCourses = ["Biology", "Chemistry", "Physics"];
          break;
        case configs.NATURAL_SCIENCE_DEPARTMENT_ID:
          excludedCourses = ["History", "Geography"];
          break;
        default:
          break;
      }

      matchingCondition.$or = [
        { departmentId: { $eq: departmentObjectId } },
        { departmentId: { $eq: new Types.ObjectId(configs.GRADE_9_AND_10_DEPARTMENT_ID) } } 
      ];
      if (excludedCourses.length > 0) {
        matchingCondition.name = { $nin: excludedCourses };
      }
    }

    if (grade) {
      matchingCondition.grade = Number(grade);
    }

    const aggregationPipeline: any[] = [];
    if (Object.keys(matchingCondition).length > 0) {
      aggregationPipeline.push({ $match: matchingCondition });
    }

    let courses;
    if (aggregationPipeline.length > 0) {
      courses = await Course.aggregate(aggregationPipeline).exec();
    } else {
      courses = await Course.find({}).exec();
    }
    const baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Courses fetched successfully!!';
    baseResponse.data = courses;

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getMocksByDepartment = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const depId = req.query.departmentId?.toString();

    if (depId && !isValidObjectId(depId)) {
      throw Error('Invalid department id sent!');
    }

    const departmentId = depId ? new ObjectId(depId) : null;

    const aggregationPipeline = [];

    // Conditionally add the $match stage
    if (departmentId) {
      aggregationPipeline.push({
        $match: { departmentId }
      });
    }

    aggregationPipeline.push(
      {
        $project: {
          _id: '$_id',
          name: '$name',
          examYear: '$examYear',
          questions: { $size: '$questions' },
          departmentId: '$departmentId',
          isStandard: '$isStandard',
          subject: '$subject'
        }
      }
    );

    // Convert the result of Mock.aggregate to an array
    const aggregatedMocks = await Mock.aggregate(aggregationPipeline).exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Mocks retrieved successfully!';
    baseResponse.data = aggregatedMocks;

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};


const getFlaggedContentDetails = async (req: Request, res: Response, next: NextFunction) => {
  try {

    const page = parseInt(req.query.page as string) || 1;
    const pageSize = parseInt(req.query.limit as string) || 1000;

    const courseNameFilter = req.query.subject as string;
    
    const pipeline = [
      {
        $lookup: {
          from: 'subchaptercontents',
          localField: 'subChapterContentId',
          foreignField: '_id',
          as: 'subChapterContent',
        },
      },
      
      {
        $unwind: '$subChapterContent',
      },
     
      {
        $lookup: {
          from: 'subchapters',
          localField: 'subChapterContent.subChapterId',
          foreignField: '_id',
          as: 'subChapter',
        },
      },
     
      {
        $unwind: '$subChapter',
      },
      
      {
        $lookup: {
          from: 'chapters',
          localField: 'subChapter.chapterId',
          foreignField: '_id',
          as: 'chapter',
        },
      },
      
      {
        $unwind: '$chapter',
      },
      
      {
        $lookup: {
          from: 'courses',
          localField: 'chapter.courseId',
          foreignField: '_id',
          as: 'course',
        },
      },
      
      {
        $unwind: '$course',
      },
      
      {
        $project: {
          _id: 1,
          chapterOrder: '$chapter.order',
          courseName: '$course.name',
          comment: '$comment',
          grade: '$course.grade',
          title: '$chapter.name'
        },
      },
    ];

    
    let flaggedContentDetails = await ContentFlag.aggregate(pipeline).exec();


    
    flaggedContentDetails = flaggedContentDetails.map(flaggedQuestionsDetail => {return {...flaggedQuestionsDetail, courseName: categorizeCourse(flaggedQuestionsDetail.courseName)}})

    if (courseNameFilter)
      flaggedContentDetails= flaggedContentDetails.filter(flaggedQuestionsDetail=> flaggedQuestionsDetail.courseName === categorizeCourse(courseNameFilter))
    

    const startIndex = (page - 1) * pageSize;
    const endIndex = startIndex + pageSize;
    flaggedContentDetails = flaggedContentDetails.slice(startIndex, endIndex);


    const baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Flagged content details fetched successfully!!';
    baseResponse.data = flaggedContentDetails;

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};


const getFlaggedQuestionsDetails = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const page = parseInt(req.query.page as string) || 1;
    const pageSize = parseInt(req.query.limit as string) || 1000;

    const courseNameFilter = req.query.subject as string;

    const pipeline = [
      {
        $lookup: {
          from: 'questions',
          localField: 'questionId',
          foreignField: '_id',
          as: 'question',
        },
      },
      {
        $unwind: '$question',
      },
      {
        $lookup: {
          from: 'courses',
          localField: 'question.courseId',
          foreignField: '_id',
          as: 'course',
        },
      },
      {
        $unwind: '$course',
      },
      {
        $project: {
          _id: 1,
          courseName: '$course.name',
          questionDescription: '$question.description',
        },
      },
    ];

    let flaggedQuestionsDetails = await QuestionFlag.aggregate(pipeline).exec();
    
    flaggedQuestionsDetails = flaggedQuestionsDetails.map(flaggedQuestionsDetail => {return {...flaggedQuestionsDetail, courseName: categorizeCourse(flaggedQuestionsDetail.courseName)}})

    if (courseNameFilter)
      flaggedQuestionsDetails= flaggedQuestionsDetails.filter(flaggedQuestionsDetail=> flaggedQuestionsDetail.courseName === categorizeCourse(courseNameFilter))
    

    const startIndex = (page - 1) * pageSize;
    const endIndex = startIndex + pageSize;
    flaggedQuestionsDetails = flaggedQuestionsDetails.slice(startIndex, endIndex);

    const baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Flagged questions details fetched successfully!!';
    baseResponse.data = flaggedQuestionsDetails;

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const toggleAdminQuestionValidation = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;

    const questionFlag: IQuestionFlag | null = await QuestionFlag.findById(id);

    if (!questionFlag) {
      throw Error('Invalid Id a of question not found')
    }

    questionFlag.adminValidated = !questionFlag.adminValidated;

    await questionFlag.save();

    const baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Admin validation toggled successfully!';
    baseResponse.data = { adminValidated: questionFlag.adminValidated };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};


const toggleAdminContentValidation = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;

    const contentFlag: IContentFlag | null = await ContentFlag.findById(id);

    if (!contentFlag) {
      throw Error('invalid Id or content not found!!')
    }

    contentFlag.adminValidated = !contentFlag.adminValidated;

    await contentFlag.save();

    const baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'Admin validation toggled successfully!';
    baseResponse.data = { adminValidated: contentFlag.adminValidated };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getCourseDetails = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const courseId = req.params.id;

    const course = await Course.findOne({ _id: courseId })
      .select("name grade description")
      .populate("image", "imageAddress -_id")
      .populate("departmentId", "name -_id")
      .lean()
      .exec();

    if (!course) {
      throw Error("Course not found with that ID.");
    }
    const chapters = await Chapter.find({ courseId })
      .sort({ order: 1 })
      .select("_id order name")
      .lean()
      .exec();

    const chapterIds = chapters.map((chapter) => chapter._id);

    const subChapters = await SubChapter.find({ chapterId: { $in: chapterIds } })
      .select("_id chapterId name order")
      .lean()
      .exec();
    const subChaptersWithContentsPromises = subChapters.map(async (subChapter) => {
      const numberOfContents = await SubChapterContent.countDocuments({ subChapterId: subChapter._id }).exec();
      return {
        ...subChapter,
        numberOfContents,
      };
    });

    const subChaptersWithContents = await Promise.all(subChaptersWithContentsPromises);

    const courseSubject = categorizeCourse(course.name as string);

    const reviewers = await Reviewer.find({ subject: { $in: [courseSubject] } }).lean().exec();

    const baseResponse = {
      success: true,
      message: "Course details retrieved successfully!",
      data: {
        course,
        chapters: chapters.map((chapter) => {
          const matchingSubChapters = subChaptersWithContents.filter((subChapter) => subChapter.chapterId.toString() === chapter._id.toString());
          const sortedSubChaptes = matchingSubChapters.sort((a, b) => {
            const orderA = a.order as number || 0;
            const orderB = b.order as number || 0;
            return orderA - orderB;
          })
          return {
            ...chapter,
            subChapters: sortedSubChaptes,
          };
        }),
        reviewers,
      },
    };

    return res.status(200).json(baseResponse);
  } catch (error) {
    next(error);
  }
};

const getCoursesAssignedToReviewer = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const reviewerId = req.body.userDetails._id.toString();

    const subChapterReviews = await SubChapterReview.find({
      reviewerId,
      status: 'pending',
    }).lean().exec();

    const courseIds = [...new Set(subChapterReviews.map(review => review.courseId.toString()))];

    const courses = await Course.find({
      _id: { $in: courseIds },
    }).select("name grade description").populate("image", "imageAddress -_id")
      .populate("departmentId", "name -_id")
      .lean()
      .exec();

    const coursesWithTopics = await Promise.all(courses.map(async (course) => {
      const numberOfTopics = await SubChapterReview.countDocuments({
        courseId: course._id
      }).exec();
      return {
        ...course,
        numberOfTopics,
      };
    }));

    const baseResponse = {
      success: true,
      message: "Courses assigned to the reviewer retrieved successfully!",
      data: {
        courses: coursesWithTopics,
      },
    };

    return res.status(200).json(baseResponse);
  } catch (error) {
    next(error);
  }
};

const getReviewerCourseDetails = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const courseId = req.params.id;
    const reviewerId = req.body.userDetails._id.toString();

    const course = await Course.findOne({ _id: courseId })
      .select("name grade description")
      .populate("image", "imageAddress -_id")
      .populate("departmentId", "name -_id")
      .lean()
      .exec();

    if (!course) {
      throw Error("Course not found with that ID.");
    }

    const chapters = await Chapter.find({ courseId })
      .sort({ order: 1 })
      .select("_id order name")
      .lean()
      .exec();

    const chapterIds = chapters.map((chapter) => chapter._id);

    const allSubChapterReviews = await SubChapterReview.find({
      chapterId: { $in: chapterIds },
      courseId,
      reviewerId,
    })
    .select("_id status subChapterId chapterId updatedAt")
    .sort({ updatedAt: -1 }) // Sort by updatedAt in descending order
    .lean()
    .exec();

    const latestReviewsMap = new Map();
    allSubChapterReviews.forEach((review) => {
      const subChapterId = review.subChapterId.toString();
      if (!latestReviewsMap.has(subChapterId)) {
        latestReviewsMap.set(subChapterId, review);
      }
    });
    
    const subChapterReviews = Array.from(latestReviewsMap.values());

    const subChaptersWithContentsPromises = subChapterReviews.map(async (subChapterReview) => {
      const subChapterDetails = await SubChapter.findOne({ _id: subChapterReview.subChapterId })
        .select("_id name chapterId order")
        .lean()
        .exec();

      const numberOfContents = await SubChapterContent.countDocuments({ subChapterId: subChapterReview.subChapterId }).exec();

      return {
        ...subChapterDetails,
        status: subChapterReview.status,
        numberOfContents,
      };
    });

    const subChaptersWithContents = await Promise.all(subChaptersWithContentsPromises);

    const chaptersWithSubChapters = chapters.filter((chapter) => {
      const hasSubChapters = subChapterReviews.some((subChapterReview) => subChapterReview.chapterId.toString() === chapter._id.toString());
      return hasSubChapters;
    });

    const subChaptersByChapter = chaptersWithSubChapters.map((chapter) => {
      const matchingSubChapters = subChaptersWithContents.filter((subChaptersWithContent) => subChaptersWithContent.chapterId.toString() === chapter._id.toString());
      return {
        ...chapter,
        subChapters: matchingSubChapters,
      };
    });

    const baseResponse = {
      success: true,
      message: "Reviewer course details retrieved successfully!",
      data: {
        course,
        chapters: subChaptersByChapter,
      },
    };

    return res.status(200).json(baseResponse);
  } catch (error) {
    next(error);
  }
};

const createChapter = async (req: Request, res: Response, next: NextFunction) => {
  try {
      const {
          name,
          description,
          summary,
          courseId,
          noOfSubChapters, 
          order,
          adminApproval,

      } = req.body;

      const userInput = {
          name, description, summary, courseId,noOfSubChapters, order, adminApproval
      }

      const { error, value } = chapterValidator(userInput, "post");

      const foundCourse = await Course.findOne({ _id: courseId }).lean().exec();

      if (!foundCourse) throw Error("Course not find  with ID.");
      await Course.findByIdAndUpdate(courseId, {noOfChapters:Number(foundCourse.noOfChapters) + 1})
      if (error) throw error

      const chapter = new Chapter({ ...value });

      const savedChapter = await chapter.save();

      let baseResponse = new BaseResponse();
      baseResponse.success = true
      baseResponse.message = 'Chapter created successfully!'
      baseResponse.data = {
          newChapter: savedChapter
      }

      return res.status(201).json({ ...baseResponse })
  } catch (error) {
      next(error)
  };
}

const getChapters = async (req: Request, res: Response, next: NextFunction) => {
  try {
      const chapters = await Chapter.find().lean().exec();
      let baseResponse = new BaseResponse();
      baseResponse.success = true
      baseResponse.message = 'Chapters retrieved successfully!'
      baseResponse.data = {
          chapters,
      }

      return res.status(200).json({ ...baseResponse });
  } catch (error) {
      next(error)
  }
}

const getChaptersOfCourse = async (req: Request, res: Response, next: NextFunction) => {
  try {
      const courseId = req.params.id;

      const foundCourse = await Course.findOne({_id: courseId}).lean().exec();
      if (!foundCourse) throw Error("Course not found with that Id.")

      const chapters = await Chapter.find({courseId}).lean().exec();
      let baseResponse = new BaseResponse();
      baseResponse.success = true
      baseResponse.message = 'Course Chapters retrieved successfully!'
      baseResponse.data = {
          chapters,
      }

      return res.status(200).json({ ...baseResponse });
  } catch (error) {
      next(error)
  }
}

const getChapter = async (req: Request, res: Response, next: NextFunction) => {
  try {
      const id = req.params.id;
      const chapter = await Chapter.findOne({ _id: id }).lean().exec();

      if (!chapter) throw Error("Chapter not found with that Id.")

      let baseResponse = new BaseResponse();
      baseResponse.success = true
      baseResponse.message = 'Chapter retrieved successfully!'
      baseResponse.data = {
          chapter,
      }

      return res.status(200).json({ ...baseResponse });

  } catch (error) {
      next(error)
  }
}

const updateChapter = async (req: Request, res: Response, next: NextFunction) => {
  try {
      const { id } = req.params;
      const chapterToBeUpdated = await Chapter.findById(id).lean().exec();

      if (!chapterToBeUpdated) throw Error("Chapter not found with that Id.")

      const {
          name,
          description,
          summary,
          courseId,
          noOfSubChapters,
          adminApproval
      } = req.body;

      let updateObject = {
          name,
          description,
          summary,
          courseId,
          noOfSubChapters,
          adminApproval
      }

      for (const key in updateObject) {
          if (!updateObject[key]) delete updateObject[key]
      }

      const { error, value } = chapterValidator(updateObject, "put");
      let foundCourse
      if (courseId){
          foundCourse = await Course.findOne({ _id: courseId }).lean().exec();
          if (!foundCourse) throw Error("Course not found with ID.");
      }
      

      if (error) throw error;

      const updatedChapter = await Chapter.findByIdAndUpdate(id, value, { new: true }).lean().exec();

      let baseResponse = new BaseResponse();
      baseResponse.success = true
      baseResponse.message = 'Chapter updated successfully!'
      baseResponse.data = {
          updatedChapter,
      }
      return res.status(200).json({ ...baseResponse })

  } catch (error) {
      next(error)
  }
}

const deleteChapter = async (req: Request, res: Response, next: NextFunction) => {
  try {
      const { id } = req.params;
      const chapterToBeDeleted = await Chapter.findById(id).lean().exec();

      if (!chapterToBeDeleted) throw Error("Chapter not found with that Id.");

      const deletedChapter = await Chapter.findByIdAndDelete(id).lean().exec();

      const course = await Course.findOne({_id: chapterToBeDeleted.courseId}).lean().exec()

      await Course.findByIdAndUpdate(course._id, {noOfChapters:Number(course.noOfChapters) -1})
      let baseResponse = new BaseResponse();
      baseResponse.success = true
      baseResponse.message = 'Chapter deleted successfully!'
      baseResponse.data = {
          deletedChapter,
      }

      return res.status(200).json({ ...baseResponse });
  } catch (error) {
      next(error)
  }
}
const getSubChapterOfChapter = async (req:Request,res:Response,next:NextFunction)=>{
  try{
    const chapterId  = req.params.id
    if(!chapterId){
      throw new Error('chapterId required')
    }
    if (chapterId){
      if (!isValidObjectId(chapterId)){
        throw new Error('Invalid chapterId')
      }

      const chapter= await Chapter.findOne({_id: chapterId}).lean().exec();
      if(!chapter)throw Error("chapter not found with this id.")
      const subChapters = await SubChapter.find({chapterId}).lean().exec();

      if (subChapters.length === 0){
        throw new Error('No Subchapter Found')
      }
      let baseResponse = new BaseResponse();
      baseResponse.data = {
        subChapters
      }
      baseResponse.success = true;
      baseResponse.message = 'Subchapter SuccessFully Retrieved!'
      return res.status(200).json({
        ...baseResponse
      })
    }
  }catch(error){
    next(error)
  }
  
  
}
const uploadImage = async (req: Request, res: Response, next: NextFunction) =>{
  const {image}= req.body

  const response= await Image.findById(image).lean().exec();

  let baseResponse= new BaseResponse();
  baseResponse.data= {
    image: response
  }
  baseResponse.success= true
  baseResponse.message= 'Image uploaded successfully!'

  return res.status(200).json({...baseResponse})
  
}
const resourceController = { 
  getCourses, 
  getCourseDetails, 
  getMocksByDepartment, 
  getFlaggedContentDetails,
  getFlaggedQuestionsDetails, 
  toggleAdminQuestionValidation, 
  toggleAdminContentValidation,
  getCoursesAssignedToReviewer,
  getReviewerCourseDetails,
  createChapter,
  getChapter,
  getChapters,
  updateChapter,
  deleteChapter,
  getChaptersOfCourse,
  getSubChapterOfChapter,
  uploadImage
}

export default resourceController