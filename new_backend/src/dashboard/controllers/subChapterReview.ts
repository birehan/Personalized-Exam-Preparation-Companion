import { Request, Response, NextFunction } from 'express';
import SubChapterReview, { ISubChapterReviewDocument } from '../models/subChapterReview';
import { subChapterContentValidator, subChapterReviewValidation, subChapterValidator } from '../../validations/joiModelValidator';
import { BaseResponse } from '../../types/baseResponse';
import SubChapter, { ISubChapter } from '../../models/subChapter';
import Reviewer from '../models/reviewer';
import mongoose, { Types } from 'mongoose';
import ContentReview from '../models/contentReview';
import SubChapterContent from '../../models/subChapterContent';
import { ObjectId } from 'mongodb';
import ContentFlag from '../../models/contentFlag';
import { isExistingReviewer } from '../../services/helpers';
import Chapter from '../../models/chapter';
import UserChapterAnalysis from '../../models/userChapterAnalysis';
import UserContentBookmark from '../../models/userContentBookmark';

const createSubChapterReview = async (req: Request, res: Response, next: NextFunction) => {
  try {
    // requestedBy should be taken from the auth middleware: it should be authorized that the user should be Admin

    const { subChapterId, reviewerId, requestedBy, chapterId, courseId } = req.body;

    const userInput = { subChapterId, reviewerId, requestedBy, chapterId, courseId };

    const { error, value } = subChapterReviewValidation(userInput, 'post');

    if (error) throw error;

    const foundReviewer = await isExistingReviewer(reviewerId);

    if(!foundReviewer){
      throw new Error("Reviewer not found with that Id or is inActive!");
    }

    const foundSubChapter = await SubChapter.findOne({_id: subChapterId}).lean().exec();

    if (!foundSubChapter){ throw Error("subchapter not found!")}

    const subChapterReview = new SubChapterReview({ ...value });

    const savedSubChapterReview = await subChapterReview.save();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'SubChapter review created successfully!';
    baseResponse.data = {
      newSubChapterReview: savedSubChapterReview,
    };

    return res.status(201).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getSubChapterReviews = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const subChapterReviews = await SubChapterReview.aggregate([
      {
        $lookup: {
          from: 'subchapters',
          localField: 'subChapterId',
          foreignField: '_id',
          as: 'subChapter',
        },
      },
      {
        $lookup: {
          from: 'reviewers',
          localField: 'reviewerId',
          foreignField: '_id',
          as: 'reviewer',
        },
      },
      {
        $lookup: {
          from: 'courses',
          localField: 'courseId',
          foreignField: '_id',
          as: 'course',
        },
      },
      {
        $unwind: '$subChapter',
      },
      {
        $unwind: '$reviewer',
      },
      {
        $unwind: '$course',
      },
      {
        $project: {
          reviewerId: '$reviewer._id',
          name: { $concat: ['$reviewer.firstName', ' ', '$reviewer.lastName'] },
          subChapterId: '$subChapter._id',
          subChapterName: '$subChapter.name',
          courseId: '$course._id',
          courseName: '$course.name',
          grade: '$course.grade',
          status: '$status',
          createdAt: '$createdAt',
          updatedAt: '$updatedAt',
        },
      },
    ]).exec();

    const baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'SubChapter reviews retrieved successfully!';
    baseResponse.data = {
      subChapterReviews,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const getSubChapterReview = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const id = req.params.id;
    const subChapterReview = await SubChapterReview.findOne({ _id: id }).lean().exec();

    if (!subChapterReview) throw Error('SubChapter review not found with that Id.');

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'SubChapter review retrieved successfully!';
    baseResponse.data = {
      subChapterReview,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const updateSubChapterReview = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const subChapterReviewToBeUpdated = await SubChapterReview.findById(id).lean().exec();

    if (!subChapterReviewToBeUpdated) throw Error('SubChapter review not found with that Id.');

    const { subChapterId, reviewerId, status, requestedBy, chapterId, courseId } = req.body;

    let updateObject = { subChapterId, reviewerId, status, requestedBy, chapterId, courseId };

    for (const key in updateObject) {
      if (!updateObject[key]) delete updateObject[key];
    }

    const { error, value } = subChapterReviewValidation(updateObject, 'put');

    if (error) throw error;

    const updatedSubChapterReview = await SubChapterReview.findByIdAndUpdate(id, value, { new: true })
      .lean()
      .exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'SubChapter review updated successfully!';
    baseResponse.data = {
      updatedSubChapterReview,
    };
    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const deleteSubChapterReview = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const subChapterReviewToBeDeleted = await SubChapterReview.findById(id).lean().exec();

    if (!subChapterReviewToBeDeleted) throw Error('SubChapter review not found with that Id.');

    const deletedSubChapterReview = await SubChapterReview.findByIdAndDelete(id).lean().exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'SubChapter review deleted successfully!';
    baseResponse.data = {
      deletedSubChapterReview,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const assignSubChaptersToReviewer = async (req: Request, res: Response, next: NextFunction) => {
  try {
      const { subChapterIds, reviewerId } = req.body;
      const requestedBy = req.body.userDetails._id.toString();

      const foundReviewer = await isExistingReviewer(reviewerId);

      if(!foundReviewer){
        throw new Error("Reviewer not found with that Id or is inActive!");
      }

      const courses = new Set<string>();
      for (const subChapterId of subChapterIds) {
        const subChapter = await SubChapter.findOne({ _id: subChapterId }).populate('chapterId').lean().exec();
        if (!subChapter) {
          throw new Error(`SubChapter not found with ID ${subChapterId}`);
        }
        const chapterId = subChapter.chapterId as any;
        courses.add(chapterId.courseId.toString());
      }

      if (courses.size !== 1) {
        throw new Error('SubChapters must belong to the same course.');
      }

      const courseId = Array.from(courses)[0];

      const existingReviews = await SubChapterReview.find({ reviewerId, status: 'pending' }).lean().exec();
      const existingReviewIds = existingReviews.map((review) => review.subChapterId.toString());


      const newReviewIds = subChapterIds.filter((subChapterId) => !existingReviewIds.includes(subChapterId));
      const newSubChapterReviews: ISubChapterReviewDocument[] = [];
      for (const subChapterId of newReviewIds) {
        const newSubChapter = await SubChapter.findOne({ _id: subChapterId }).lean().exec();
        if (!newSubChapter) {
          throw new Error(`SubChapter not found with ID ${subChapterId}`);
        }

        const newSubChapterReview = await SubChapterReview.create({
          subChapterId,
          reviewerId,
          status: 'pending',
          requestedBy: requestedBy,
          chapterId: newSubChapter.chapterId.toString(),
          courseId,
        });

        newSubChapterReviews.push(newSubChapterReview);
      }

      const newContentReviews = [];
      for (const subChapterReview of newSubChapterReviews) {
        const subChapterContents = await SubChapterContent.find({ subChapterId: subChapterReview.subChapterId }).select("_id").lean().exec();

        for (const subChapterContent of subChapterContents) {
          const contentReview = await ContentReview.create({
            subChapterContentId: subChapterContent._id,
            subChapterReviewId: subChapterReview._id,
            reviewerId,
            status: 'pending',
            requestedBy: requestedBy
          });

          newContentReviews.push(contentReview);
        }
      }

      const response = {
        existingSubChapterReviews: existingReviews,
        newSubChapterReviews
      };

      return res.status(200).json({
        success: true,
        message: 'SubChapters assigned to reviewer successfully!',
        data: response,
      });
  } catch (error) {
    next(error);
  }
};

const getSubChapterContents = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;

    const subChapter = await SubChapter.findById(id).select("_id name order").lean().exec();

    if (!subChapter) {
      throw Error('Sub-chapter not found with that Id.');
    }

    const subChapterContents = await SubChapterContent.find({ subChapterId: subChapter._id }).sort({ order: 1 }).lean().exec();

    const [contentFlags, contentReviews] = await Promise.all([
      ContentFlag.find({ subChapterContentId: { $in: subChapterContents.map(content => content._id) } })
        .populate({ path: 'userId', select: 'firstName lastName avatar', populate: { path: 'avatar', model: 'Image', select: '-_id imageAddress' } })
        .lean().exec(),
      ContentReview.find({ subChapterContentId: { $in: subChapterContents.map(content => content._id) } })
        .populate({ path: 'reviewerId', select: 'firstName lastName avatar', populate: { path: 'avatar', model: 'Image', select: '-_id imageAddress' } })
        .lean().exec(),
    ]);

    const contentFlagsMap = contentFlags.reduce((map, flag:any) => {
      if (!map.has(flag.subChapterContentId.toString())) {
        map.set(flag.subChapterContentId.toString(), []);
      }
      map.get(flag.subChapterContentId.toString()).push({
        ...flag,
        userId: flag.userId as any ? { ...flag.userId, avatar: flag.userId.avatar ? flag.userId.avatar.imageAddress : null } : null,
      });
      return map;
    }, new Map<string, any>());

    const contentReviewsMap = contentReviews.reduce((map, review:any) => {
      if (!map.has(review.subChapterContentId.toString())) {
        map.set(review.subChapterContentId.toString(), []);
      }
      map.get(review.subChapterContentId.toString()).push({
        ...review,
        reviewerId: review.reviewerId ? { ...review.reviewerId, avatar: review.reviewerId.avatar ? review.reviewerId.avatar.imageAddress : null } : null,
      });
      return map;
    }, new Map<string, any>());

    const subChapterContentsWithDetails = subChapterContents.map(content => ({
      ...content,
      contentFlags: contentFlagsMap.get(content._id.toString()) || [],
      contentReviews: contentReviewsMap.get(content._id.toString()) || [],
    }));

    const baseResponse = {
      success: true,
      message: 'Sub-chapter retrieved successfully!',
      data: {
        subChapter: {
          ...subChapter,
          contents: subChapterContentsWithDetails,
        },
      },
    };

    return res.status(200).json(baseResponse);
  } catch (error) {
    next(error);
  }
};



const adminUpdateSubChapterContent = async ( req: Request, res: Response, next: NextFunction ) => {
  try {
    const { id } = req.params;
    const subChapterContentToBeUpdated = await SubChapterContent.findById(id).lean().exec();

    if (!subChapterContentToBeUpdated)
      throw Error('SubChapterContent not found with that Id.');

    const { title, content, subChapterId, adminApproval, order } = req.body;

    let updateObject = {
      title,
      content,
      subChapterId,
      adminApproval,
      order
    };

    Object.keys(updateObject).forEach(
      (key) => updateObject[key] === undefined && delete updateObject[key]
    );

    let foundSubChapter;
    if (subChapterId) {
      foundSubChapter = await SubChapter.findById(subChapterId);
      if (!foundSubChapter) throw Error("Sub chapter doesn't exist");
    }

    const { error, value } = subChapterContentValidator(updateObject, 'put');

    if (error) throw error;

    const updatedSubChapterContent = await SubChapterContent.findByIdAndUpdate(
      id,
      value,
      { new: true }
    ).lean().exec();

    let baseResponse = new BaseResponse();
    baseResponse.success = true;
    baseResponse.message = 'SubChapterContent updated successfully!';
    baseResponse.data = {
      updatedSubChapterContent,
    };

    return res.status(200).json({ ...baseResponse });
  } catch (error) {
    next(error);
  }
};

const reviewerGetSubChapterContents = async ( req: Request, res: Response, next: NextFunction ) => {
  try {
    const id = req.params.id;
    const reviewerId = req.body.userDetails._id.toString();

    const foundReview: any = await SubChapterReview.find({ subChapterId: id, reviewerId }).sort({ updatedAt: -1 }).limit(1).lean().exec();

    const assigned = foundReview[0];

    if(!assigned) {throw Error("This subChapter is not assigned to the reviewer!")}

    const subChapter = await SubChapter.aggregate([
      {
        $match: {
          _id: new ObjectId(id),
        },
      },
      {
        $lookup: {
          from: 'subchaptercontents',
          localField: '_id',
          foreignField: 'subChapterId',
          as: 'contents',
        },
      },
      {
        $unwind: '$contents',
      },
      {
        "$sort": {
          "contents.order": 1
        }
      },
      {
        $lookup: {
          from: 'contentreviews',
          localField: 'contents._id',
          foreignField: 'subChapterContentId',
          as: 'contentReview',
        },
      },
      {
        $addFields: {
          'contents.contentReview': {
            $arrayElemAt: [
              {
                $filter: {
                  input: '$contentReview',
                  as: 'review',
                  cond: {
                    $and: [
                      { $eq: ['$$review.reviewerId', new ObjectId(reviewerId)] },
                      { $eq: ['$$review.subChapterReviewId', new ObjectId(assigned._id.toString())] }, //this will make sure the contents are latest
                    ]
                  },
                },
              },
              0,
            ],
          },
        },
      },
      {
        $unset: ['contents.contentReview.subChapterContentId', 'contents.contentReview.createdAt', 'contents.contentReview.updatedAt', 'contents.contentReview.__v'],
      },
      {
        $group: {
          _id: {
            _id: '$_id',
            name: '$name',
          },
          contents: { $push: '$contents' },
        },
      },
      {
        $project: {
          _id: '$_id._id',
          name: '$_id.name',
          contents: {
            $map: {
              input: '$contents',
              as: 'content',
              in: {
                _id: '$$content._id',
                subChapterId: '$$content.subChapterId',
                title: '$$content.title',
                content: '$$content.content',
                order: '$$content.order',
                contentReview: '$$content.contentReview',
              },
            },
          },
        },
      },
    ]);

    if (!subChapter || subChapter.length === 0) {

      const foundSubChapter = await SubChapter.findById(id).select("_id name order").lean().exec();

      if (!foundSubChapter) {
        throw Error('Sub-chapter not found with that Id.');
      }
      
      let baseResponse = {
        success: true,
        message: 'Sub-chapter retrieved successfully!',
        data: {
          subChapter: {
            ...foundSubChapter,
            contents: []
        }
      }};
  
      return res.status(200).json(baseResponse);
    }

    let baseResponse = {
      success: true,
      message: 'Sub-chapter retrieved successfully!',
      data: {
        subChapter: subChapter[0],
      },
    };

    return res.status(200).json(baseResponse);
  } catch (error) {
    next(error);
  }
};

const reviewerSubmitSubChapterReview = async ( req: Request, res: Response, next: NextFunction ) => {
  try {
    const reviewerId = req.body.userDetails._id.toString();
    const subChapterId = req.params.id;

    const foundSubChapter = await SubChapterReview.find({ subChapterId, reviewerId }).sort({ updatedAt: -1 }).limit(1).lean().exec();

    const subChapterReview = foundSubChapter[0]

    if (!subChapterReview) {
      throw new Error('SubChapterReview not found with that subChapterId.');
    }

    const pendingContentReviews = await ContentReview.findOne({
      subChapterReviewId: subChapterReview._id,
      status: 'pending',
    }).lean().exec();

    if (pendingContentReviews) {
      throw Error('There is content not reviewed yet!');
    }

    const updatedSubChapterReview = await SubChapterReview.findByIdAndUpdate(
      subChapterReview._id,
      { status: 'approved' },
      { new: true }
    ).lean().exec();

    const baseResponse = {
      success: true,
      message: 'SubChapterReview updated successfully!',
      data: { updatedSubChapterReview },
    };

    return res.status(200).json(baseResponse);
  } catch (error) {
    next(error);
  }
};



const createSubChapterContent = async (req: Request, res: Response, next: NextFunction) => {
  try {
      const {
          title, content,
          subChapterId, 
          order, 
          adminApproval,
      } = req.body;
      const reviewerId= req.body.userDetails._id.toString()

      const userInput = { title, content, subChapterId, order, adminApproval}

      const { error, value } = subChapterContentValidator(userInput,"post");

      if (error) throw error

      const foundSubChapter = await SubChapter.findById(subChapterId)
      if(!foundSubChapter) throw Error("Sub chapter doesn't exist")

      const matchingReview = await SubChapterReview.findOne({
        subChapterId: subChapterId,
        reviewerId
      }).sort({ updatedAt: -1 }).limit(1).lean().exec()
  
      if (!matchingReview) {
        throw Error("Not assigned subchapter for the given subChapterId.");
      }

      const subChapterContent = new SubChapterContent({...value});

      const savedSubChapterContent = await subChapterContent.save();

      
      let contentReview = null;

    const isReviewer = req.body.dashboardUser.role === 'REVIEWER';
    
    if (isReviewer) {
      contentReview = new ContentReview({
        subChapterContentId: savedSubChapterContent._id,
        subChapterReviewId: matchingReview._id, 
        status: 'pending',
        reviewerId: req.body.userDetails._id.toString(), 
        comment: 'No comments!', 
        requestedBy: null
      });

      await contentReview.save();
    }

      let baseResponse = new BaseResponse();
      baseResponse.success = true
      baseResponse.message = 'SubChapterContent created successfully!'
      baseResponse.data = {
        newSubChapterContent: savedSubChapterContent,
        contentReview
      }

      return res.status(201).json({...baseResponse})
  } catch (error) {
      next(error)
  };
}

const deleteSubChapterContent = async (req: Request, res: Response, next: NextFunction) => {
  try {
      const { id } = req.params;
      const subChapterContentToBeDeleted = await SubChapterContent.findById(id).lean().exec();

      if (!subChapterContentToBeDeleted) throw Error("SubChapterContent not found with that Id.");

      const deletedContentReviews = await ContentReview.deleteMany({subChapterContentId: id}).lean().exec();

      const deletedSubChapterContent = await SubChapterContent.findByIdAndDelete(id).lean().exec();

      //TODO: damp the deleted content on trash collection

      let baseResponse = new BaseResponse();
      baseResponse.success = true
      baseResponse.message = 'SubChapterContent deleted successfully!'
      baseResponse.data = {
          deletedSubChapterContent,
      }

      return res.status(200).json({...baseResponse});
  } catch (error) {
      next(error)
  }
}

const createSubChapter = async (req: Request, res: Response, next: NextFunction) => {
  try {
      const {
          name,
          chapterId,
          order
      } = req.body;

      const userInput = {
          name, chapterId, order
      }

      const { error, value } = subChapterValidator(userInput, "post");

      const foundChapter = await Chapter.findOne({ _id: chapterId }).lean().exec();

      if (!foundChapter) throw Error("Chapter not found with ID.");
      const newNoOfSubChapters:number = Number( foundChapter.noOfSubChapters)+ 1
      await Chapter.findByIdAndUpdate(chapterId, {noOfSubChapters: newNoOfSubChapters}).lean().exec();

      if (error) throw error

      const subChapter = new SubChapter({ ...value });

      const savedSubChapter = await subChapter.save();
      const chapter = await Chapter.findOne({ _id: chapterId }).lean().exec();

    if (!chapter) throw Error('Chapter not found.');

    const courseId = chapter.courseId;
    const userId = req.body.userDetails._id.toString();

    const role = req.body.dashboardUser.role; 
    let subChapterReview = null
    console.log(role)
    if (role === 'REVIEWER') {
      subChapterReview = new SubChapterReview({
        subChapterId: savedSubChapter._id,
        reviewerId: userId, 
        status: 'pending',
        chapterId,
        courseId
      });

      await subChapterReview.save();
    }

      let baseResponse = new BaseResponse();
      baseResponse.success = true
      baseResponse.message = 'Sub-chapter created successfully!'
      baseResponse.data = {
          newSubChapter: savedSubChapter,
          subChapterReview
      }

      return res.status(201).json({ ...baseResponse })
  } catch (error) {
      next(error)
  };
}
const getSubChapters = async (req: Request, res: Response, next: NextFunction) => {
  try {
      const userId = req.body.user._id.toString();
      const { chapterId } = req.params;
      const foundChapter = await Chapter.findOne({ _id: chapterId }).lean().exec();

      if (!foundChapter) throw Error("Chapter not found with ID.");

      const subChapters = await SubChapter.find({chapterId,}).lean().exec();
      const completedSubChapters = await UserChapterAnalysis.findOne({userId, chapterId, }).lean().exec();

      let baseResponse = new BaseResponse();
      baseResponse.success = true
      baseResponse.message = 'Sub-chapters retrieved successfully!'
      baseResponse.data = {
          subChapters,
          completedSubChapters: completedSubChapters?.completedSubChapters || [],
      }

      return res.status(200).json({ ...baseResponse });
  } catch (error) {
      next(error)
  }
}

const getSubChapter = async (req: Request, res: Response, next: NextFunction) => {
  try {
      const id = req.params.id;

     let subChapter=  await SubChapter.aggregate([
      {
        $match: {
          _id: new ObjectId(id),
        },
      },
      {
        $lookup: {
          from: 'subchaptercontents',
          localField: '_id',
          foreignField: 'subChapterId',
          as: 'contents',
        },
      },
      {
          $unwind: {
            path: '$contents',
            preserveNullAndEmptyArrays: true,
          },
        },
      {
        $sort: {
          'contents.order': 1,
        },
      },
      {
        $group: {
          _id: '$_id',
          name: { $first: '$name' },
          chapterId: { $first: '$chapterId' },
          createdAt: { $first: '$createdAt' },
          updatedAt: { $first: '$updatedAt' },
          contents: { $push: '$contents' },
          order: { $first: '$order' }
        },
      },
    ], { maxTimeMS: 60000, allowDiskUse: true });      
    if (!subChapter || subChapter.length === 0) throw Error("No topic found with that ID!")



      let baseResponse = new BaseResponse();
      baseResponse.success = true;
      baseResponse.message = 'Sub-chapter retrieved successfully!';
      baseResponse.data = {
          subChapter: subChapter[0]
      };

      return res.status(200).json({ ...baseResponse });

  } catch (error) {
      next(error)
  }
}

const updateSubChapter = async (req: Request, res: Response, next: NextFunction) => {
  try {
      const { id } = req.params;
      const subChapterToBeUpdated = await SubChapter.findById(id).lean().exec();

      if (!subChapterToBeUpdated) throw Error("Sub-chapter not found with that Id.")

      const {
          name,
          contents,
          chapterId,
          order
      } = req.body;

      let updateObject = {
          name,
          contents,
          chapterId,
          order
      }

      for (const key in updateObject) {
          if (!updateObject[key]) delete updateObject[key]
      }

      const { error, value } = subChapterValidator(updateObject, "put");

      if (error) throw error;

      if(chapterId !== null && chapterId !== undefined){
        const foundChapter = await Chapter.findOne({ _id: chapterId }).lean().exec();
        if (!foundChapter) throw Error("Chapter not found with ID.");
      }

      const updatedSubChapter = await SubChapter.findByIdAndUpdate(id, value, { new: true }).lean().exec();

      let baseResponse = new BaseResponse();
      baseResponse.success = true
      baseResponse.message = 'Sub-chapter updated successfully!'
      baseResponse.data = {
          updatedSubChapter,
      }
      return res.status(200).json({ ...baseResponse })

  } catch (error) {
      next(error)
  }
}

const deleteSubChapter = async (req: Request, res: Response, next: NextFunction) => {
  try {
      const { id } = req.params;
      const subChapterToBeDeleted = await SubChapter.findById(id).lean().exec();

      if (!subChapterToBeDeleted) throw Error("Sub-chapter not found with that Id.");

      const deletedSubChapter = await SubChapter.findByIdAndDelete(id).lean().exec();

      const {chapterId} = deletedSubChapter
      const chapter = await Chapter.findById(chapterId).lean().exec();

      await Chapter.findByIdAndUpdate(chapterId, {noOfSubChapters: Number(chapter.noOfSubChapters) - 1},{new:true}).lean().exec();
  

      let baseResponse = new BaseResponse();
      baseResponse.success = true
      baseResponse.message = 'Chapter deleted successfully!'
      baseResponse.data = {
          deletedSubChapter,
      }

      return res.status(200).json({ ...baseResponse });
  } catch (error) {
      next(error)
  }
}

const subChapterReviewControllers = {
  createSubChapterReview,
  getSubChapterReviews,
  getSubChapterReview,
  updateSubChapterReview,
  deleteSubChapterReview,
  assignSubChaptersToReviewer,
  getSubChapterContents,
  adminUpdateSubChapterContent,
  reviewerGetSubChapterContents,
  reviewerSubmitSubChapterReview,
  updateSubChapter,
  createSubChapterContent,
  deleteSubChapterContent,
  createSubChapter,
  getSubChapter,
  getSubChapters,
  deleteSubChapter,
};

export default subChapterReviewControllers
