import { Router } from "express";
import generalDepartmentController from "../controllers/generalDepartment";
import isAuthenticated from "../middlewares/authenticate";

const router = Router();
router.get("/", generalDepartmentController.getGeneralDepartments);
router.post("/", generalDepartmentController.createGeneralDepartment);
router.get("/:id", generalDepartmentController.getGeneralDepartment);
router.put("/:id", generalDepartmentController.updateGeneralDepartment);
router.delete("/:id", generalDepartmentController.deleteGeneralDepartment);

export default router;