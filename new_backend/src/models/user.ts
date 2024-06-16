import { Schema, Document, Model, model } from 'mongoose';
import * as bcrypt from "bcrypt";
import Joi, { number } from 'joi';

export interface IUserDocument extends Document {
  email_phone: string
  firstName: string
  lastName: string
  gender: string
  password: string
  department: Schema.Types.ObjectId
  highSchool: string
  region: string
  grade: Number
  resetToken: string
  avatar: Schema.Types.ObjectId
  howPrepared: string
  preferredMethod: string
  studyTimePerDay: string
  motivation: string
  challengingSubjects: [string]
  reminder: string
  createdAt: Date
  updatedAt: Date
  isGoogleSignup?: boolean
}

interface UserModel extends Model<IUserDocument>{
  login(email_phone: string, password: string): any
}


const UserSchema: Schema<IUserDocument, UserModel> = new Schema(
  {
    email_phone: {
      type: String,
      required: [true, "email or phone number is required"],
      lowercase: true,
      trim: true,
      unique: true,
      index:true,
      validate: {
        validator: function (value) {
          const emailRegex = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
          const phoneRegex = /^\+\d{11,}$/; // Update this regex for your specific phone number format
          return emailRegex.test(value) || phoneRegex.test(value);
        },
        message: 'Please fill a valid email address or phone number'
      }
   },
    firstName: {
      type: String,
      required: [true, 'Please enter a your first name!']
    },
    lastName: {
      type: String,
      required: [true, 'Please enter a your last name!']
    },
    gender: {
      type: String,
      default: "Male/Female"
    },
    password: {
      type: String,
      required: [true, 'Please enter a password'],
      minlength: [6, 'Minimum password length is 6 characters'],
    },
    department: {
      type: Schema.Types.ObjectId,
      ref:'Department',
      default: null
    },
    highSchool: {
      type: String,
      default: "My School"
    },
    region: {
      type: String,
      default: "My region"
    },
    grade: {
      type: Number,
      default: 12
    },
    avatar: {
      type: Schema.Types.ObjectId,
      ref: 'Image',
      default: null,
      required: false
    },
    resetToken: {
      type: String,
      default: ""
    },
    howPrepared: {
      type: String,
      default: ""
    },
    preferredMethod: {
      type: String,
      default: ""
    },
    studyTimePerDay: {
      type: String,
      default: ""
    },
    motivation: {
      type: String,
      default: ""
    },
    challengingSubjects: {
      type: [{ type: String }],
      default: []
    },
    reminder: {
      type: String,
      default: ""
    },
    isGoogleSignup: {
      type: Boolean,
      default: false
    }
  },
  {
    timestamps: {
      createdAt: 'createdAt',
      updatedAt: 'updatedAt'
    }
  }
)

UserSchema.pre('remove', { document: true, query: false }, async function (next) {
  next()
})

// fire a function before user is saved to db
UserSchema.pre('save', async function(next) {
  if (!this.isGoogleSignup) {
    const salt = await bcrypt.genSalt();
    this.password = await bcrypt.hash(this.password, salt);
  }
  next();
});

// static method to login a user
UserSchema.statics.login = async function(email_phone, password) {
  const user = await this.findOne({ email_phone });
  if (user) {
    const auth = await bcrypt.compare(password, user.password);
    if (auth) {
      return user;
    }
    throw Error('incorrect email/phone_number or password!');
  }
  throw Error('incorrect email/phone_number or password!');
};


const User = model<IUserDocument, UserModel>('User', UserSchema)

export const userValidation = Joi.object({
  email_phone: Joi.string().min(6).required()
  .custom((value, helpers) => {
    const emailRegex = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
    const phoneRegex = /^\+\d{11,}$/; //phone numbers with "+" sign

    if (!emailRegex.test(value) && !phoneRegex.test(value)) {
      return helpers.error('any.invalid');
    }
    return value;
  }).trim().lowercase().messages({
    'any.invalid': 'Please fill a valid email address or phone number',
  }),
  firstName: Joi.string().required().trim(),
  lastName: Joi.string().required().trim(),
  password: Joi.string().min(6).required().trim(),
  department: Joi.string().hex().length(24).trim().default(null),
  highSchool: Joi.string().trim(),
  region: Joi.string().trim(),
  gender: Joi.string().trim(),
  grade: Joi.number(),
  resetToken: Joi.string().default(""),
  avatar: Joi.string().hex().length(24).default(null),
  howPrepared: Joi.string().default(""),
  preferredMethod: Joi.string().default(""),
  studyTimePerDay: Joi.string().default(""),
  motivation: Joi.string().default(""),
  challengingSubjects: Joi.array().items(Joi.string()).default([]),
  reminder: Joi.string().default("")
});

export const updateUserValidation = Joi.object({
  firstName: Joi.string().trim(),
  lastName: Joi.string().trim(),
  department: Joi.string().hex().length(24).trim(),
  highSchool: Joi.string().trim(),
  region: Joi.string().trim(),
  gender: Joi.string().trim(),
  grade: Joi.number(),
  avatar: Joi.string().hex().length(24).optional(),
  howPrepared: Joi.string().default(""),
  preferredMethod: Joi.string().default(""),
  studyTimePerDay: Joi.string().default(""),
  motivation: Joi.string().default(""),
  challengingSubjects: Joi.array().items(Joi.string()).default([]),
  reminder: Joi.string().default("")
});

export default User
