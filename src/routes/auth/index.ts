import { Router } from "express";
import { agencyRouter } from "./agency";
import { userRouter } from "./user";

const authRouter = Router()


authRouter.use("/user", userRouter)
authRouter.use("/agency", agencyRouter)

export {
    authRouter
}