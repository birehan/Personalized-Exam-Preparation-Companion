import { Document, Schema, model } from "mongoose";

export interface INotification extends Document {
  title: string;
  content: string;
  date: Date;
}

const NotificationSchema: Schema<INotification> = new Schema(
  {
    title: {
      type: String,
      required: [true, "Title is required"],
    },
    content: {
      type: String,
      required: [true, "Content is required"],
    },
    date: {
      type: Date,
      required: [true, "Date is required"],
    },
  },
  {
    timestamps: {
      createdAt: 'createdAt',
      updatedAt: 'updatedAt',
    },
  }
);

const Notification = model<INotification>("Notification", NotificationSchema);

export default Notification;
