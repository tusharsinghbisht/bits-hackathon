import { Router, Request, Response } from "express";
import Doc from "../../models/Doc";
import { ensureAgency, verifyAgencyOwnership } from "../../middleware/agency";
import User from "../../models/User";
import fileUpload from "express-fileupload";
import path from "path";
import fs from "fs";
import { ensureUser, verifyUserOwnership } from "../../middleware/user";
import { AgencyRequest, UserRequest } from "../../types/request";

const docsRouter = Router();
docsRouter.post(
  "/upload",
  ensureAgency,
  async (req: AgencyRequest, res: Response): Promise<void> => {
    try {
      const { userId, type } = req.body;
      const agencyId = req.agencyId;

      if (!req.files || !req.files.file) {
        res.status(400).json({ message: "File is required" });
        return;
      }

      if (!userId || !type) {
        res.status(400).json({ message: "All fields are required" });
        return;
      }

      // Find user by mobile number instead of _id
      const user = await User.findOne({ mobile: userId });
      if (!user) {
        res.status(404).json({ message: "User not found" });
        return;
      }

      const file = req.files.file as fileUpload.UploadedFile;

      const uploadDir = path.join(__dirname, "../../uploads/docs");
      const filePath = path.join(uploadDir, `${Date.now()}-${file.name}`);

      if (!fs.existsSync(uploadDir)) {
        fs.mkdirSync(uploadDir, { recursive: true });
      }

      await file.mv(filePath);

      const doc = new Doc({
        file: `/docs/${path.basename(filePath)}`,
        userId: user._id, // Use the user's _id from database
        agencyId,
        type,
      });

      await doc.save();
      res.status(201).json({ message: "Document uploaded successfully", doc });
    } catch (error) {
      res.status(500).json({ message: "Error uploading document", error });
    }
  }
);

docsRouter.get(
  "/agency/:docId",
  ensureAgency,
  verifyAgencyOwnership,
  async (req: AgencyRequest, res: Response) => {
    try {
      const doc = req.doc;

      if (!doc) {
        res.status(404).json({ message: "Document not found" });
        return;
      }

      res.status(200).json(doc);
    } catch (error) {
      res.status(500).json({ message: "Error fetching document", error });
    }
  }
);
/*
COMMENTED BECAUSE IT WAS INTERFERRING WITH GET_ALL REQUEST FOR USER
docsRouter.get(
  "/user/:docId",
  ensureUser,
  verifyUserOwnership,
  async (req: UserRequest, res: Response) => {
    try {
      const doc = req.doc;

      if (!doc) {
        res.status(404).json({ message: "Document not found" });
        return;
      }

      res.status(200).json(doc);
    } catch (error) {
      res.status(500).json({ message: "Error fetching document", error });
    }
  }
);
*/

docsRouter.get(
  "/agency/get_all",
  ensureAgency,
  async (req: AgencyRequest, res: Response) => {
    try {
      const agencyId = req.agencyId;

      const docs = await Doc.find({ agencyId: agencyId });
      res.status(200).json(docs);
    } catch (error) {
      res
        .status(500)
        .json({ message: "Error fetching agency documents", error });
    }
  }
);

docsRouter.get(
  "/user/get_all",
  ensureUser,
  async (req: UserRequest, res: Response) => {
    try {
      const userId = req.userId;

      const docs = await Doc.find({ userId });
      res.status(200).json(docs);
    } catch (error) {
      res
        .status(500)
        .json({ message: "Error fetching agency documents", error });
    }
  }
);

docsRouter.delete(
  "/delete/:docId",
  ensureAgency,
  verifyAgencyOwnership,
  async (req: Request, res: Response) => {
    try {
      const { docId } = req.params;

      await Doc.findByIdAndDelete(docId);
      res.status(200).json({ message: "Document deleted successfully" });
    } catch (error) {
      res.status(500).json({ message: "Error deleting document", error });
    }
  }
);

export { docsRouter };
{ }