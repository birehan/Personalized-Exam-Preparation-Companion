import { Schema, Document, Model, model } from 'mongoose';
import * as bcrypt from 'bcrypt';
import Joi from 'joi';

export enum UserRole {
  SUPER_ADMIN = 'SUPER_ADMIN',
  ADMIN = 'ADMIN',
  REVIEWER = 'REVIEWER',
  REVIEWER_ADMIN = 'REVIEWER_ADMIN',
}

export interface IDashboardUserDocument extends Document {
  email_phone: string;
  password: string;
  role: UserRole;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

interface DashboardUserModel extends Model<IDashboardUserDocument> {
  login(email_phone: string, password: string): any;
}

const DashboardUserSchema: Schema<IDashboardUserDocument, DashboardUserModel> = new Schema(
  {
    email_phone: {
      type: String,
      required: [true, 'Email or phone number is required'],
      lowercase: true,
      trim: true,
      unique: true,
      index: true,
      validate: {
        validator: function (value) {
          const emailRegex = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
          const phoneRegex = /^\+\d{11,}$/; // Update this regex for your specific phone number format
          return emailRegex.test(value) || phoneRegex.test(value);
        },
        message: 'Please fill a valid email address or phone number',
      },
    },
    password: {
      type: String,
      required: [true, 'Please enter a password'],
      minlength: [6, 'Minimum password length is 6 characters'],
    },
    role: {
      type: String,
      enum: Object.values(UserRole),
      required: true,
    },
    isActive: {
      type: Boolean,
      default: true,
    }
  },
  {
    timestamps: {
        createdAt: 'createdAt',
        updatedAt: 'updatedAt'
    }
}
);

// Middleware to hash the password before saving to the database
DashboardUserSchema.pre('save', async function (next) {
  const salt = await bcrypt.genSalt();
  this.password = await bcrypt.hash(this.password, salt);
  next();
});

// Static method to login a user
DashboardUserSchema.statics.login = async function (email_phone, password) {
  const user = await this.findOne({ email_phone });
  if (user) {
    const auth = await bcrypt.compare(password, user.password);
    if (auth) {
      return user;
    }
    throw Error('Incorrect email/phone_number or password!');
  }
  throw Error('Incorrect email/phone_number or password!');
};

const DashboardUser = model<IDashboardUserDocument, DashboardUserModel>('DashboardUser', DashboardUserSchema);

export const dashboardUserValidation = Joi.object({
  email_phone: Joi.string().min(6).required().trim().lowercase(),
  password: Joi.string().min(6).required().trim(),
  role: Joi.string().valid(...Object.values(UserRole)).required(),
  isActive: Joi.boolean().default(true)
});

export const dashboardUserUpdateValidation = Joi.object({
  roles: Joi.array().items(Joi.string().valid(...Object.values(UserRole))),
  isActive: Joi.boolean(),
});

export default DashboardUser;
