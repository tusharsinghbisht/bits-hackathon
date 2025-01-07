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
      min: Date.now(),
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
  },
  { timestamps: true }
);

const User = model<IUser>("User", userSchema);

export default User;
