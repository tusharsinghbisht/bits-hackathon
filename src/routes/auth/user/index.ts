import { Router, Request, Response } from "express";
import User from "../../../models/User";
import { generateOTP, getExpiryDate } from "../../../utils/otp";
import { sendOTP } from "../../../utils/sms";
import { generateToken } from "../../../utils/jwt";

const userRouter = Router();

userRouter.post("/register", async (req: Request, res: Response) => {
  const { name, dob, gender, aadhaar, mobile } = req.body;

  try {
    const user = new User({ name, dob, gender, aadhaar, mobile });
    await user.save();
    res.status(201).json({ message: "User registered successfully" });
  } catch (error: any) {
    res.status(400).json({ error: error.message });
  }
});

userRouter.post("/login/send-otp", async (req: Request, res: Response) => {
  const { mobile } = req.body;

  if (!mobile) {
    return res.status(500).json({ message: "Invalid request" });
  }

  try {
    const user = await User.findOne({ mobile });
    if (!user) return res.status(404).json({ message: "User not found" });

    const otp = generateOTP();
    user.otp = otp;
    user.otpExpiresAt = getExpiryDate();
    await user.save();

    await sendOTP(mobile, otp);

    res.status(200).json({ message: "OTP sent successfully" });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

userRouter.post("/login/verify-otp", async (req: Request, res: Response) => {
  const { mobile, otp } = req.body;

  if (!mobile || !otp) {
    return res.status(500).json({ message: "Invalid request" });
  }


  try {
    const user = await User.findOne({ mobile });
    if (!user) return res.status(404).json({ message: "User not found" });

    if (user.otp !== otp || new Date() > user.otpExpiresAt!) {
      return res.status(400).json({ message: "Invalid or expired OTP" });
    }

    user.otp = "";
    user.otpExpiresAt = new Date();
    await user.save();

    const token = generateToken(user._id.toString());

    res.status(200).json({ message: "Login successful", token });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

export { userRouter };
