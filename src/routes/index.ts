import { Router } from "express";
import { authRouter } from "./auth";
import { profileRouter } from "./profile";
import { docsRouter } from "./docs";


const router = Router()


router.use("/auth", authRouter)
router.use("/docs", docsRouter)
router.use("/profile", profileRouter)

export {
    router
}