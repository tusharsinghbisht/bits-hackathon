import twilio from 'twilio';
import dotenv from 'dotenv';

dotenv.config();

const client = twilio(
  process.env.TWILIO_ACCOUNT_SID,
  process.env.TWILIO_AUTH_TOKEN
);

export const sendOTP = async (mobile: string, otp: string) => {
  try {
    // Format phone number to E.164 format
    const formattedNumber = mobile.startsWith('+') ? mobile : `+91${mobile}`;
    
    console.log('Sending OTP to:', formattedNumber); // Debug log
    
    const message = await client.messages.create({
      body: `Your OTP for CareSathi App is: ${otp}`,
      to: formattedNumber,
      from: process.env.TWILIO_PHONE_NUMBER
    });
    
    console.log('Twilio Message SID:', message.sid);
    return message;
  } catch (error: any) {
    console.error('Twilio Error Details:', {
      code: error.code,
      message: error.message,
      moreInfo: error.moreInfo
    });
    throw new Error(error.message || 'Failed to send OTP');
  }
};
