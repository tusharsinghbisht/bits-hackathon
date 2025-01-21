import express, { Request, Response } from "express";
import { router } from "./routes";
import dotenv from "dotenv"
import "colors"
import { connectDB } from "./db";
import path from "path"
import fileUpload from "express-fileupload"

// Load env vars from root directory
dotenv.config({ path: path.join(__dirname, '../.env') })

const app = express();

const PORT: number = 8000;

app.use(express.json())
app.use(express.urlencoded({ extended: false }))
app.use(fileUpload())

app.use("/api/v1", router)
app.use("/docs", express.static(path.join(__dirname, "../uploads/docs"))); // Serve uploaded files

connectDB().then(() => {
  app.listen(PORT, () => {
    console.log(`Server is running PORT ${PORT}`.magenta);
  });
})

