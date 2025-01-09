import { Router, Request, Response } from "express";
import User from "../../models/User";
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

profileRouter.put(
  "/:userId/update",
  ensureAgency,
  async (req: Request, res: Response) => {
    try {
      const updatedUser = await User.findByIdAndUpdate(
        req.params.userId,
        req.body,
        { new: true }
      );
      if (!updatedUser) {
        res.status(404).json({ message: "User not found" });
        return;
      }
      res.json(updatedUser);
    } catch (error) {
      res.status(500).json({ message: "Server error", error });
    }
  }
);

profileRouter.get("/search", async (req: Request, res: Response) => {
  const { name, mobile } = req.query;
  try {
    const query: any = {};
    if (name) query.name = { $regex: name, $options: "i" };
    if (mobile) query.mobile = mobile;

    const users = await User.find(query);
    res.json(users);
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
});

profileRouter.put(
  "/update",
  ensureUser,
  async (req: UserRequest, res: Response) => {
    const userId = req.userId; // Assuming you have user authentication with userId in the request
    try {
      const updatedUser = await User.findByIdAndUpdate(userId, req.body, {
        new: true,
      });
      if (!updatedUser) {
        res.status(404).json({ message: "User not found" });
        return;
      }
      res.json(updatedUser);
    } catch (error) {
      res.status(500).json({ message: "Server error", error });
    }
  }
);

profileRouter.put(
  "/family/add/:memberId",
  ensureUser,
  async (req: UserRequest, res: Response) => {
    try {
      const familyMemberId = req.body.memberId;
      const user = await User.findById(req.userId);
      if (!user) {
        res.status(404).json({ message: "User not found" });
        return;
      }

      if (user.family) {
        user.family.push(familyMemberId);
      }
      await user.save();

      res.json({ message: "Family member added", family: user.family });
    } catch (error) {
      res.status(500).json({ message: "Server error", error });
    }
  }
);

// Remove family member from the user by userId
profileRouter.put(
  "/family/remove/:memberId",
  ensureUser,
  async (req: UserRequest, res: Response) => {
    try {
      const { familyMemberId } = req.body.memberId;
      const user = await User.findById(req.userId);
      if (!user) {
        res.status(404).json({ message: "User not found" });
        return;
      }

      if (user.family) {
        user.family = user.family.filter(
          (memberId) => memberId.toString() !== familyMemberId
        );
      }

      await user.save();

      res.json({ message: "Family member removed", family: user.family });
    } catch (error) {
      res.status(500).json({ message: "Server error", error });
    }
  }
);

export { profileRouter };
