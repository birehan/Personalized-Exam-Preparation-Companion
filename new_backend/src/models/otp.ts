import mongoose, { Schema, Document, Model, model } from 'mongoose';

export interface IOtp extends Document {
  email_phone: string
  otp: string
  createdAt: Date
  expiresAt: Date
}


const otpSchema: Schema<IOtp> = new mongoose.Schema({
  email_phone: {
    type: String,
    unique: true,
    index: true,
    required: [true, 'email or phone number is required'],
  },
  otp: {
    type: String,
    required: [true, 'Please enter an OTP']
  },
  createdAt: {
    type: Date,
    required: true
  },
  expiresAt: {
    type: Date,
    required: true
  }
});

const Otp = model<IOtp>('Otp', otpSchema);

export default Otp;