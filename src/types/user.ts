import { Types } from 'mongoose'

export interface IUser {
  name: string;
  dob: Date;
  gender: "male" | "female" | "other";
  aadhaar: String;
  mobile: String;
  otp: String;
  otpExpiresAt: Date;
  bloodGroup?: String,
  height?: Number, // in centimeters
  weight?: Number, // in kilograms
  acuteConditions?: String[],
  chronicConditions?: String[],
  allergies?: String[],
  pastSurgeries?: String[],
  medications?: String[],
  family?: Types.ObjectId[]
}
