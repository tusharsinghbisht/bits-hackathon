import { Response, NextFunction } from "express";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import User from "../models/User";
import Doc from "../models/Doc";
import { UserRequest } from "../types/request";

dotenv.config();

const JWT_SECRET = process.env.JWT_SECRET!;


export const ensureUser = async (
  req: UserRequest,
  res: Response,
  next: NextFunction
) => {
  const token = req.headers["authorization"]?.split(" ")[1];

  if (!token) {
    res.status(401).json({ message: "Access denied. No token provided." });
    return;
  }

  try {
    const decoded: any = jwt.verify(token, JWT_SECRET);
    const userId = decoded.id;

    const user = await User.findById(userId);
    if (!user) {
      res.status(404).json({ message: "User not found" });
      return;
    }

    req.userId = userId
    next();
  } catch (error) {
    res.status(403).json({ message: "Invalid or expired token" });
  }
};

export const verifyUserOwnership = async (
  req: UserRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { docId } = req.params;

    if (!docId) {
      res.status(400).json({ message: "Document ID is required" });
      return;
    }

    const doc = await Doc.findById(docId);
    if (!doc) {
      res.status(404).json({ message: "Document not found" });
      return;
    }

    if (doc.agencyId.toString() !== req.userId) {
      res
        .status(403)
        .json({
          message: "Unauthorized: Document does not belong to your agency",
        });
      return;
    }

    req.doc = doc;
    next();
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error verifying agency ownership", error });
  }
};
