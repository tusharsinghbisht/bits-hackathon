import { model, Schema } from "mongoose";
import { IAgency } from "../types/agency";

const agencySchema = new Schema<IAgency>(
  {
    agencyId: {
      type: String,
      unique: true,
      required: true,
    },
    email: {
      type: String,
      unique: true,
      required: true,
    },
    password: {
      type: String,
      required: true,
    },
    name: {
      type: String,
      required: true,
    },
    type: {
      type: String,
      required: true,
      lowercase: true,
    },
    location: {
      type: String,
      required: true,
    },
  },
  { timestamps: true }
);

const Agency = model<IAgency>("Agency", agencySchema);

export default Agency;
