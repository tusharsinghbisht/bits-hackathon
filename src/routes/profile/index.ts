import { Router, Request, Response } from "express";
import User from "../../models/User";
import Agency from "../../models/Agency";
import { ensureUser } from "../../middleware/user";
import { UserRequest } from "../../types/request";
import { ensureAgency } from "../../middleware/agency";

const profileRouter = Router();

profileRouter.get(
  "/get",
  ensureUser,
  async (req: UserRequest, res: Response) => {
    try {
      const user = await User.findById(req.userId).populate("family");
      if (!user) {
        res.status(404).json({ message: "User not found" });
        return;
      }
      res.json(user);
    } catch (error) {
      res.status(500).json({ message: "Server error", error });
    }
  }
);

profileRouter.get(
  "/get/:userId",
  ensureAgency,
  async (req: Request, res: Response) => {
    try {
      const user = await User.findById(req.params.userId).populate("family");
      if (!user) {
        res.status(404).json({ message: "User not found" });
        return;
      }
      res.json(user);
    } catch (error) {
      res.status(500).json({ message: "Server error", error });
    }
  }
);

// New route to fetch agency details by MongoDB _id
profileRouter.get(
  "/agency/:agencyId",
  ensureUser,
  async (req: Request, res: Response) => {
    try {
      const { agencyId } = req.params;
      const agency = await Agency.findById(agencyId); // Use findById to search by MongoDB _id

      if (!agency) {
        res.status(404).json({ message: "Agency not found" });
        return;
      }

      res.status(200).json(agency);
    } catch (error) {
      res.status(500).json({ message: "Error fetching agency details", error });
    }
  }
);

export { profileRouter };

