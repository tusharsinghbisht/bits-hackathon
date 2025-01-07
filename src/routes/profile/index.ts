import { Router, Request, Response } from "express";

const profileRouter = Router()

profileRouter.get("/:userId", async (req: Request, res: Response) => {

})


profileRouter.put("/:userId/update", async (req: Request, res: Response) => {
    
})


profileRouter.get("/search", async (req: Request, res: Response) => {
    
})

profileRouter.put("/update", async (req: Request, res: Response) => {
    
})


profileRouter.put("/family/add/:userId", async (req: Request, res: Response) => {
    
})

profileRouter.put("/family/remove/:userId", async (req: Request, res: Response) => {
    
})



export {
    profileRouter
}