import { Document, Schema, model } from "mongoose";


export interface ICoinIncentivization extends Document {
    userId: Schema.Types.ObjectId; 
    coin: string;
    referralCount: number;
}

const CoinIncentivizationSchema: Schema<ICoinIncentivization> = new Schema({
    userId: {
        type: Schema.Types.ObjectId,
        ref: 'User', 
        required: [true, "User Id is required"]
    },
    coin: {
        type: String,
        required: [true, "Coin is required"]
    },
    referralCount: {
        type: Number,
        default: 0
    }
},
{
    timestamps: {
        createdAt: 'createdAt',
        updatedAt: 'updatedAt'
    }
});

const CoinIncentivization = model<ICoinIncentivization>("CoinIncentivization", CoinIncentivizationSchema);

export default CoinIncentivization;
