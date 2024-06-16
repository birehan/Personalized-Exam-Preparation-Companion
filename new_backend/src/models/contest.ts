import { Document, Schema, model } from 'mongoose';

export interface IContestDocument extends Document {
  description: string;
  departmentId: Schema.Types.ObjectId;
  liveRegister: number,
  virtualRegister: number,
  title: string;
  startsAt: Date;
  endsAt: Date;
}

const ContestSchema: Schema<IContestDocument> = new Schema(
  {
    description: {
      type: String,
      default: "🚀 Ignite your academic journey with our exclusive High School Contest! 🏆 Dive into diverse subjects, enhance critical skills, and win exciting prizes!",
    },
    departmentId: {
      type: Schema.Types.ObjectId,
      ref: "Department",
      required: [true, "Department is required."]
    },
    title: {
      type: String,
      default: "SkillBridge Contest"
    },
    liveRegister: {
      type: Number,
      default: 0
    },
    virtualRegister: {
      type: Number,
      default: 0
    },
    startsAt: {
      type: Date,
      required: true,
    },
    endsAt: {
      type: Date,
      required: true,
      validate: {
        validator: function (endsAt: Date) {
          return endsAt > this.startsAt;
        },
        message: 'End date must be greater than start date.',
      },
    },
  },
  {
    timestamps: {
      createdAt: 'createdAt',
      updatedAt: 'updatedAt',
    },
  }
);

const Contest = model<IContestDocument>('Contest', ContestSchema);

export default Contest;
