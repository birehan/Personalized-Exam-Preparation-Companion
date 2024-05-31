import { Router } from "express";
import dashBoardUserController from "../controllers/dashboardUser";
import dashboardContentController from "../controllers/dashboardContent";
import reviewerController from "../controllers/reviewer";
import resourceController from "../controllers/resource";
import subChapterReviewControllers from "../controllers/subChapterReview";
import contentReviewControllers from "../controllers/contentReview";
import questionReviewControllers from "../controllers/questionReview";
import mockReviewControllers from "../controllers/mockReview";
import dashboardAuthenticator from "../auth/authentication/dashboardAuthentication";
import { isAdmin } from "../auth/authorization/isAdmin";
import { isReviewer } from "../auth/authorization/isReviewer";
import userSpecificController from "../controllers/userSpecificDashboard";
import contestController from "../controllers/contest";
import uploader from "../../middlewares/uploader";
import { isAdminOrReviewerAdmin } from "../auth/authorization/isAdminAndReviewerAdmin";
import automationController from "../../automations/userScoreCategory";

const router = Router();

//Authentication related endpoints
router.post("/user/login", dashBoardUserController.dashboardUserLogin);
router.get("/user/superAdmin", dashBoardUserController.createSuperAdmin);
router.get("/user/currentUser", dashboardAuthenticator, dashBoardUserController.currentDashboardUser);
router.post('/user', dashBoardUserController.createDashboardUser)
router.get('/user', dashBoardUserController.getDashboardUsers)
router.put('/user/changePassword', dashboardAuthenticator, dashBoardUserController.changePassword)
router.delete('/user/deactivate/:id', dashBoardUserController.toggleDashboardUserStatus)

//Authentication related endpoints
router.post("/user/login", dashBoardUserController.dashboardUserLogin);
router.get("/user/superAdmin", dashBoardUserController.createSuperAdmin);

//Automation related endpoints
router.put("/automation/scoreCategories", automationController.updateUserScoreCategories);

//Home page content routes
router.get("/dailyActiveUsers", dashboardAuthenticator, isAdmin, dashboardContentController.getDailyActivityData);
router.get("/staticData", dashboardAuthenticator, isAdmin, dashboardContentController.getStaticData);
router.get("/mockQuizStat", dashboardAuthenticator, isAdmin, dashboardContentController.getQuizMockStatsController);
router.get("/questionStat", dashboardAuthenticator, isAdmin, dashboardContentController.getQuestionStatsController);

//Reviewer related endpoints
router.get('/reviewer', reviewerController.getReviewers)
router.get('/reviewer/:id', reviewerController.getReviewer)
router.put('/reviewer/updateProfile', uploader ,dashboardAuthenticator, reviewerController.updateReviewerProfile)
// router.put('/reviewer/:id', reviewerController.updateReviewer)
router.get('/reviewerAssignedMocks', dashboardAuthenticator,  isReviewer, reviewerController.getMocksByReviewerId)
router.get('/reviewersForMock/:mockId', dashboardAuthenticator, isAdmin, reviewerController.getReviewersForMock)


//Admin related endpoints 
router.put('/admin/:id', dashBoardUserController.updateAdmin)


//courses related endpoints
router.get('/courses', dashboardAuthenticator, resourceController.getCourses)
router.get('/mocks', dashboardAuthenticator, isAdmin, resourceController.getMocksByDepartment)
router.get('/flaggedContents', dashboardAuthenticator, isAdmin, resourceController.getFlaggedContentDetails)
router.put('/flaggedContent/approve/:id', dashboardAuthenticator, isAdmin, resourceController.toggleAdminContentValidation)
router.get('/flaggedQuestions', dashboardAuthenticator, isAdmin, resourceController.getFlaggedQuestionsDetails)
router.put('/flaggedQuestion/approve/:id', dashboardAuthenticator, isAdmin, resourceController.toggleAdminQuestionValidation)
router.get('/getCourseDetail/:id', dashboardAuthenticator, isAdminOrReviewerAdmin, resourceController.getCourseDetails)
router.get('/reviewerCourses',dashboardAuthenticator, isReviewer, resourceController.getCoursesAssignedToReviewer)
router.get('/reviewerCourseDetail/:id', dashboardAuthenticator, isReviewer, resourceController.getReviewerCourseDetails)
router.post('/chapter', dashboardAuthenticator, resourceController.createChapter)
router.get('/chapter', dashboardAuthenticator, resourceController.getChapters)
router.get('/chapterOfCourse/:id', dashboardAuthenticator, resourceController.getChaptersOfCourse)
router.get('/subchapterOfChapter/:id', dashboardAuthenticator, resourceController.getSubChapterOfChapter)

router.get('/chapter/:id', dashboardAuthenticator, resourceController.getChapter)
router.put('/chapter/:id', dashboardAuthenticator, resourceController.updateChapter)
router.delete('/chapter/:id', dashboardAuthenticator, resourceController.deleteChapter)


//Review related endpoints
router.post('/subChapterReview', subChapterReviewControllers.createSubChapterReview)
router.post('/assignSubChapterReviewer', dashboardAuthenticator, isAdmin, subChapterReviewControllers.assignSubChaptersToReviewer)
router.get('/subChapterReview', subChapterReviewControllers.getSubChapterReviews)
router.get('/subChapterReview/:id', subChapterReviewControllers.getSubChapterReview)
router.put('/subChapterContent/:id', dashboardAuthenticator, subChapterReviewControllers.adminUpdateSubChapterContent)
router.get('/subChapterContent/:id', dashboardAuthenticator,subChapterReviewControllers.getSubChapterContents)
router.get('/reviewerGetSubChapterContent/:id', dashboardAuthenticator, isReviewer,subChapterReviewControllers.reviewerGetSubChapterContents)
router.put('/subChapterReview/:id', subChapterReviewControllers.updateSubChapterReview)
router.put('/reviewerSubmitContentReview/:id', dashboardAuthenticator, isReviewer, subChapterReviewControllers.reviewerSubmitSubChapterReview)
router.delete('/subChapterReview/:id', subChapterReviewControllers.deleteSubChapterReview)
router.put('/updateSubchapter/:id', dashboardAuthenticator, subChapterReviewControllers.updateSubChapter)
router.post('/subChapterContent/create', dashboardAuthenticator, subChapterReviewControllers.createSubChapterContent)
router.delete('/subChapterContent/:id', dashboardAuthenticator, subChapterReviewControllers.deleteSubChapterContent)
router.post('/subchapter', dashboardAuthenticator, subChapterReviewControllers.createSubChapter)
router.get('/subchapter', dashboardAuthenticator, subChapterReviewControllers.getSubChapters)
router.get('/subchapter/:id', dashboardAuthenticator, subChapterReviewControllers.getSubChapter)
router.put('/subchapter/:id', dashboardAuthenticator, subChapterReviewControllers.updateSubChapter)
router.delete('/subchapter/:id', dashboardAuthenticator, subChapterReviewControllers.deleteSubChapter)


//Content Review related endpoints
router.post('/contentReview', contentReviewControllers.createContentReview)
router.get('/contentReview', contentReviewControllers.getContentReviews)
router.get('/contentReview/:id', contentReviewControllers.getContentReview)
router.put('/contentReview/:id', contentReviewControllers.updateContentReview)
router.put('/reviewerApproveContent/:id', dashboardAuthenticator, isReviewer, contentReviewControllers.reviewerContentApproval)
router.delete('/contentReview/:id', contentReviewControllers.deleteContentReview)


//question review related endpoints
router.post('/questionReview', dashboardAuthenticator, isAdmin, questionReviewControllers.createQuestionReview)
router.get('/questionReview', dashboardAuthenticator, questionReviewControllers.getQuestionReviews)
router.get('/questionReview/:id', dashboardAuthenticator, questionReviewControllers.getQuestionReview)
router.put('/questionReview/:id', dashboardAuthenticator, questionReviewControllers.updateQuestionReview)
router.delete('/questionReview/:id', dashboardAuthenticator, isAdmin, questionReviewControllers.deleteQuestionReview)
router.get('/questionDetails/:id', dashboardAuthenticator, questionReviewControllers.getQuestionDetails)
router.put('/questionUpdate/:id', dashboardAuthenticator, questionReviewControllers.updateQuestion)

//question review related endpoints
router.post('/mockReview', mockReviewControllers.createMockReview)
router.post('/mockReview/assignReview', dashboardAuthenticator, isAdmin, mockReviewControllers.assignMockToReviewer)
router.post('/mockReview/addQuestion', dashboardAuthenticator, isAdmin, mockReviewControllers.addQuestionToMock)
router.get('/mockReview', mockReviewControllers.getMockReviews)
router.get('/mockForReview/:id', dashboardAuthenticator, mockReviewControllers.getMockQuestionsWithStatus)
router.get('/mockReview/:id', dashboardAuthenticator, isAdmin, mockReviewControllers.getMockReview)
router.put('/mockReview/:id', dashboardAuthenticator, mockReviewControllers.updateMockReview)
router.delete('/mockReview/:id', dashboardAuthenticator, isAdmin, mockReviewControllers.deleteMockReview)
router.put('/adminMockApproval/:id', dashboardAuthenticator, isAdmin, mockReviewControllers.updateMockAdminApproval)


//dashboard to specific user stats
router.get('/student/getUsers', dashboardAuthenticator, isAdmin, userSpecificController.getUsers)
router.get('/student/staticData/:userId', dashboardAuthenticator, isAdmin, userSpecificController.getStaticData)
router.get('/student/userDailyActivity/:userId', dashboardAuthenticator, isAdmin, userSpecificController.getUserDailyActivity)
router.get('/student/mockQuizStat/:userId', dashboardAuthenticator, isAdmin, userSpecificController.getQuizMockStats)



//dashboard contest related routes
router.get('/searchQuestions', dashboardAuthenticator, isAdmin, contestController.searchQuestions)
router.post('/contest', dashboardAuthenticator, isAdmin, contestController.createContest)
router.post('/contest/prizes', dashboardAuthenticator, isAdmin, contestController.createPrize)
router.get('/contest/prizes', dashboardAuthenticator, isAdmin, contestController.getPrizesByStanding)
router.post('/contest/contestPrize', dashboardAuthenticator, isAdmin, contestController.createContestPrize)
router.post('/contest/category', dashboardAuthenticator, isAdmin, contestController.createContestCategory)
router.post('/contest/question', dashboardAuthenticator, isAdmin, contestController.createContestQuestion)
router.get('/contest/getPreviousContest', dashboardAuthenticator, isAdmin, contestController.getPreviousContests)
router.get('/contest/getLiveContest', dashboardAuthenticator, isAdmin, contestController.getLiveContests)
router.get('/contest/getUpcomingContest', contestController.getUpComingContests)
router.put('/contest/question/:id', dashboardAuthenticator, isAdmin, contestController.updateContestQuestion)
router.get('/contest/question/:id', dashboardAuthenticator, isAdmin, contestController.getContestQuestionsByCategoryId)
router.delete('/contest/deleteContest/:contestId', dashboardAuthenticator, isAdmin, contestController.deleteContest)
router.get('/contest/rank/:id', dashboardAuthenticator, isAdmin, contestController.getContestRanking)
router.get('/contest/registeredUsers/:id', dashboardAuthenticator, isAdmin, contestController.getRegisteredUsers)
router.put('/contest/:id', dashboardAuthenticator, isAdmin, contestController.updateContest)
router.get('/contest/:id', dashboardAuthenticator, isAdmin, contestController.getContestDetails)
router.delete('/contest/:id', dashboardAuthenticator, isAdmin, contestController.deleteContestQuestion)

router.post('/image', uploader, resourceController.uploadImage)


export default router;
