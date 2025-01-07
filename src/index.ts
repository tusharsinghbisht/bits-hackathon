import express, { Request, Response } from "express";
import { router } from "./routes";
import dotenv from "dotenv"
import "colors"
import { connectDB } from "./db";


dotenv.config()

const app = express();

const PORT: number = 8000;

app.use(express.json())
app.use(express.urlencoded({ extended: false }))

app.use("/api/v1", router)

connectDB().then(() => {
  app.listen(PORT, () => {
    console.log(`Server is running PORT ${PORT}`.magenta);
  });
})
