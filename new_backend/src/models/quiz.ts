import { required } from "joi";
import { Document, Schema, model } from "mongoose";

  export interface IQuiz extends Document {
    //   courseId: Schema.Types.ObjectId;
      name: String;
      questions: [Schema.Types.ObjectId];
      courseId: Schema.Types.ObjectId;
      userId: Schema.Types.ObjectId;
      chapters: [Schema.Types.ObjectId];
    }
    
    const QuizSchema: Schema<IQuiz> = new Schema({
      courseId:{
        type:Schema.Types.ObjectId,
        ref:'Course',
        required:[true,"chapter Id is required"]
      },
      chapters:{
        type: [{type:Schema.Types.ObjectId, ref: "Chapter"}],
        required: [true,"chapters are required"]
      },
      userId:{
        type:Schema.Types.ObjectId,
        ref:'User',
        required:[true,"user Id is required"]
      },
      name:{
        type: String,
        default:"Quiz"
      },
      questions:{
        type: [{type:Schema.Types.ObjectId, ref: "Question"}],
        required:[true,"questions is required to create quiz."],
        default: []
      }
    },
    {
        timestamps: {
          createdAt: 'createdAt',
          updatedAt: 'updatedAt'
        }
      }
    );
    
    const Quiz = model<IQuiz>("Quiz", QuizSchema);
    
    export default Quiz;