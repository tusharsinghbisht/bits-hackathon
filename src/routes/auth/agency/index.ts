import { Request, Response, Router } from "express";

const agencyRouter = Router()


agencyRouter.post("/register", async (req: Request, res:Response) => {
    res.send("Agency register")
})


agencyRouter.post("/login", async (req: Request, res:Response) => {
    res.send("Agency login")
})



export {
    agencyRouter
}