import twilio from 'twilio';
import dotenv from 'dotenv';

dotenv.config();

const accountSid = process.env.TWILIO_ACCOUNT_SID!;
const authToken = process.env.TWILIO_AUTH_TOKEN!;
const twilioPhoneNumber = process.env.TWILIO_PHONE_NUMBER!;

const client = twilio(accountSid, authToken);

export const sendOTP = async (mobile: string, otp: string): Promise<void> => {
  try {
    await client.messages.create({
      body: `Your OTP for login is: ${otp}`,
      from: twilioPhoneNumber,
      to: `+91${mobile}`,
    });
  } catch (error) {
    throw new Error('Failed to send OTP');
  }
};
