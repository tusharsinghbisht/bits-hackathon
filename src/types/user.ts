export interface IUser {
  name: string;
  dob: Date;
  gender: "male" | "female" | "other";
  aadhaar: String;
  mobile: String;
  otp: String;
  otpExpiresAt: Date;
}
