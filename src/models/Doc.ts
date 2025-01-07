import { model, Schema, Types } from "mongoose";
import { DocType, IDoc } from "../types/doc";

const docSchema = new Schema<IDoc>(
  {
    file: {
      type: String,
      required: true,
    },
    userId: {
      type: Types.ObjectId,
      required: true,
    },
    agencyId: {
      type: Types.ObjectId,
      required: true,
    },
    type: {
      type: String,
      required: true,
      lowercase: true,
      enum: DocType,
    },
  },
  { timestamps: true }
);

const Doc = model("Doc", docSchema);

export default Doc;
