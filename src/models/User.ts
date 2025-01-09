import { model, Schema } from "mongoose";
import { IUser } from "../types/user";

const userSchema = new Schema<IUser>(
  {
    name: {
      type: String,
      required: true,
    },
    dob: {
      type: Date,
      required: true,
    },
    gender: {
      type: String,
      lowercase: true,
      enum: ["male", "female", "other"],
    },
    aadhaar: {
      type: String,
      required: true,
      unique: true,
      match: /^\d{12}$/,
    },
    mobile: {
      type: String,
      required: true,
      unique: true,
      match: /^\+?[1-9]\d{1,14}$/,
    },
    otp: { type: String },
    otpExpiresAt: { type: Date },
    bloodGroup: { type: String },
    height: { type: Number }, 
    weight: { type: Number },
    acuteConditions: [{ type: String }],
    chronicConditions: [{ type: String }],
    allergies: [{ type: String }],
    pastSurgeries: [{ type: String }],
    medications: [{ type: String }],
    family: [{ type: Schema.Types.ObjectId, ref: "User" }],
  },
  { timestamps: true }
);

const User = model<IUser>("User", userSchema);

export default User;
