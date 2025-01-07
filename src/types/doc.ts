import { Types } from "mongoose";

export interface IDoc {
  file: String;
  userId: String;
  agencyId: String;
  type: TDocType;
}

export type TDocType = "report" | "prescription";
export const DocType = ["report", "prescription"];
