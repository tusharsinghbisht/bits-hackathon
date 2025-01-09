import { Response, NextFunction } from "express";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import Doc from "../models/Doc";
import Agency from "../models/Agency";
import { AgencyRequest } from "../types/request";

dotenv.config();

const JWT_SECRET = process.env.JWT_SECRET!

export const ensureAgency = async (req: AgencyRequest, res: Response, next: NextFunction) => {
  try {
    const token = req.headers.authorization?.split(" ")[1];
    if (!token) {
      res.status(401).json({ message: "Access denied. No token provided." });
      return
    }
    
    const decoded: any = jwt.verify(token, JWT_SECRET);
    const agencyId = decoded.id;

    const agency = await Agency.findById(agencyId);
    if (!agency) {
      res.status(404).json({ message: "Agency not found" });
      return
    }

    req.agencyId = agencyId;
    next();
  } catch (error) {
    res.status(403).json({ message: "Invalid or expired token", error });
  }
};


export const verifyAgencyOwnership = async (req: AgencyRequest, res: Response, next: NextFunction) => {
  try {
    const { docId } = req.params;

    if (!docId) {
      res.status(400).json({ message: "Document ID is required" });
      return
    }

    const doc = await Doc.findById(docId);
    if (!doc) {
      res.status(404).json({ message: "Document not found" });
      return
    }

    if (doc.agencyId.toString() !== req.agencyId) {
      res.status(403).json({ message: "Unauthorized: Document does not belong to your agency" });
      return
    }

    req.doc = doc
    next();
  } catch (error) {
    res.status(500).json({ message: "Error verifying agency ownership", error });
  }
};
