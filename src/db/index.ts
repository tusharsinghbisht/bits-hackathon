import mongoose from "mongoose"
import dotenv from 'dotenv';
import "colors"

dotenv.config();

const dbURI = process.env.MONGO_URI

export const connectDB = async () => {
    try {
        await mongoose.connect(dbURI || "", { dbName: "bits-hack" })
        console.log("MonogoDB connected successfully...".cyan)
    }
    catch (error) {
        console.error(`MongoDB connection failed: ${error}`.bgRed);
        process.exit(1);
    }
}