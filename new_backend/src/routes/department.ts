import { Router } from "express";
import departmentController from "../controllers/department";
import isAuthenticated from "../middlewares/authenticate";

const router = Router();
router.get("/", departmentController.getDepartments);
router.post("/", departmentController.createDepartment);
router.get("/:id", departmentController.getDepartment);
router.put("/:id", departmentController.updateDepartment);
router.delete("/:id", departmentController.deleteDepartment);

export default router;