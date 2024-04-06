import dotenv from "dotenv";
dotenv.config();

const DB_URI = process.env.MONGO_URI || "mongodb://127.0.0.1:27017/exam_prep";
const SERVER_URL = process.env.SERVER_URL || "http://localhost:";
const PORT = process.env.PORT || 3000;
const JWT_SECRET = process.env.JWT_SECRET || "tempSeceret";
const OPENAI_API_KEY = process.env.OPENAI_API_KEY;

const EMAIL = process.env.EMAIL;
const PASSWORD = process.env.PASSWORD;
const OAUTH_CLIENT_ID = process.env.OAUTH_CLIENT_ID;
const OAUTH_CLIENT_SECRET = process.env.OAUTH_CLIENT_SECRET;
const OAUTH_REFRESH_TOKEN = process.env.OAUTH_REFRESH_TOKEN;
const OAUTH_ACCESS_TOKEN = process.env.OAUTH_ACCESS_TOKEN;

const configs = {
  DB_URI,
  SERVER_URL,
  PORT,
  EMAIL,
  PASSWORD,
  JWT_SECRET,
  OPENAI_API_KEY,
  OAUTH_CLIENT_ID,
  OAUTH_CLIENT_SECRET,
  OAUTH_REFRESH_TOKEN,
  OAUTH_ACCESS_TOKEN,
};

export default configs;
