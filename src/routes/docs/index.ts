import { Router, Request, Response } from "express";


const docsRouter = Router()


docsRouter.post("/upload", async (req: Request, res: Response) => {

})


docsRouter.get("/get/:docId", async (req: Request, res: Response) => {

})

docsRouter.get("/get/:userId/get_all", async (req: Request, res: Response) => {
    
})


docsRouter.get("/get/:agencyId/get_all", async (req: Request, res: Response) => {
    
})


docsRouter.delete("/delete/:docId", async (req: Request, res: Response) => {
    
})

export {
    docsRouter
}