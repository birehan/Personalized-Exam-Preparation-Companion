import * as dotenv from 'dotenv';
import axios from 'axios';

import { Request, Response, NextFunction } from 'express';
import * as admin from 'firebase-admin';

import { initializeApp, applicationDefault, cert } from 'firebase-admin/app';
import { getFirestore, Timestamp, FieldValue, Filter } from 'firebase-admin/firestore';
import Notification from '../models/notification';
import { isEmailOrPhoneNumber } from '../services/helpers';
import User from '../models/user';

dotenv.config();

const serviceAccount = {
  type: process.env.FIREBASE_TYPE,
  project_id: process.env.FIREBASE_PROJECT_ID,
  private_key_id: process.env.FIREBASE_PRIVATE_KEY_ID,
  private_key: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n'),
  client_email: process.env.FIREBASE_CLIENT_EMAIL,
  client_id: process.env.FIREBASE_CLIENT_ID,
  auth_uri: process.env.FIREBASE_AUTH_URI,
  token_uri: process.env.FIREBASE_TOKEN_URI,
  auth_provider_x509_cert_url: process.env.FIREBASE_AUTH_PROVIDER_CERT_URL,
  client_x509_cert_url: process.env.FIREBASE_CLIENT_CERT_URL,
  universe_domain: process.env.FIREBASE_UNIVERSAL_DOMAIN,
}

initializeApp({
  credential: admin.credential.cert(serviceAccount as any)
});

const db = getFirestore();

interface FCMResponse {
    error?: {
      message: string;
    };
}



const sendNotification = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const today = new Date();
    today.setHours(0, 0, 0, 0); 

    const notification = await Notification.findOne({
      date: {
        $gte: today,
        $lt: new Date(today.getTime() + 24 * 60 * 60 * 1000), 
      },
    });
    if (!notification){
      throw Error('No message for this day!')
    }
  const allUserTokens = await getAllUserTokens();
  // to send notification locally
  // const notification = { title: req.body.title,  content: req.body.content};

  for (const userInfo of allUserTokens) {
    
    const message = {
      notification: {
        title: notification.title,
        body: notification.content,
      },
      token: userInfo.device_token,
    }

    try {
      const response:any = await admin.messaging().send(message);

      if (response.error) {
        console.error(`Error sending notification to user ${userInfo.device_token}:`, response.error.message);
      }

    } catch (error) {
      console.error(`Error sending notification to user ${userInfo.device_token}:`, error.message);
    }
  }

  return res.status(200).json({ success: true, message: "Notification sent successfully!" });
  } catch (error) {
    next(error);
  }
}
async function getAllUserTokens() {

    const citiesRef = db.collection('users_device_token');
    const snapshot = await citiesRef.get();
    const token_data = []

    snapshot.forEach(doc => {
      token_data.push(doc.data())
    });
  
    return token_data;
  }

  const sendMessageToPhoneNumbersOfUsers = async (phoneNumbers: string[], message: string) => {
    try {
      for (const phoneNumber of phoneNumbers) {
        const phoneType = isEmailOrPhoneNumber(phoneNumber);
        if (phoneType === 'Phone Number') {
          await axios({
            url: process.env.SMS_URL,
            method: "POST",
            data: {
              'msg': message,
              'phone': phoneNumber,
              'token': process.env.SMS_TOKEN
            }
          });
        }
      }
  
      return { success: true, message: "Messages sent successfully!", data: { status: "Successful" } };
    } catch (error) {
      console.error("Error sending messages:", error);
      throw error;
    }
  };
  
  const sendMessageToAllUsers = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { message } = req.body;
  
      const users = await User.find({}, 'email_phone').lean().exec();
  
      const phoneNumbers: string[] = [];
      for (const user of users) {
        const phoneType = isEmailOrPhoneNumber(user.email_phone);
        if (phoneType === 'Phone Number') {
          phoneNumbers.push(user.email_phone);
        }
      }
  
      const result = await sendMessageToPhoneNumbersOfUsers(phoneNumbers, message);

      return res.status(200).json(result);
    } catch (error) {
      next(error);
    }
  };

const notificationControllers = {
  sendNotification,
  sendMessageToAllUsers
};

export default notificationControllers;