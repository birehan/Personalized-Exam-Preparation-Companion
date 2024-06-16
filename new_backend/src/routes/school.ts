import { Router } from "express";
import isAuthenticated from "../middlewares/authenticate";
import schoolControllers from './../controllers/school';

const router = Router();

router.post("/", schoolControllers.createSchool);
router.get("/", schoolControllers.getAllSchools);
router.get("/profileData", schoolControllers.getSchoolsAndDepartments);
router.get("/:id", schoolControllers.getSchoolById);
router.put("/:id", schoolControllers.updateSchoolById);
router.delete("/:id", schoolControllers.deleteSchoolById);


export default router;
