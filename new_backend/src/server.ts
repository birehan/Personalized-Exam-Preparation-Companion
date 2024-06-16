import mongoose from "mongoose";
import configs from "./config/configs";
import app from "./app";

mongoose.set('strictQuery', false)
mongoose
  .connect(configs.DB_URI)
  .then(() => {
    console.log("Connected to mongodb...");
    app.listen(configs.PORT, () => {
      return console.log(
        `Express is listening at http://localhost:${configs.PORT}`
      );
    });
  })
  .catch((err: any) => console.log("Error occurred while connecting", err));