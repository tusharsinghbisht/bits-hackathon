import { Request, Response, Router } from "express";
import { comparePassword, hashPassword } from "../../../utils/hash";
import { generateToken } from "../../../utils/jwt";
import Agency from "../../../models/Agency";

const agencyRouter = Router();

agencyRouter.post("/register", async (req: Request, res: Response) => {
  const { agencyId, email, password, name, location, type } = req.body;

  if (!agencyId || !email || !password || !type || !location || !name) {
    res.status(400).json({ message: "All fields are required" });
    return;
  }

  try {
    const hashedPassword = await hashPassword(password);

    const newAgency = new Agency({
      agencyId,
      email,
      password: hashedPassword,
      name,
      location,
      type,
    });

    await newAgency.save();

    res.status(201).json({ message: "User registered successfully" });
  } catch (error: any) {
    res.status(400).json({ error: error.message });
  }
});

// Login Route
agencyRouter.post("/login", async (req: Request, res: Response) => {
  const { agencyId, password } = req.body;

  try {
    const agency = await Agency.findOne({ agencyId });
    if (!agency) {
      res.status(404).json({ message: "User not found" });
      return;
    }

    const isPasswordValid = await comparePassword(
      password,
      agency.password as string
    );
    if (!isPasswordValid) {
      res.status(400).json({ message: "Invalid credentials" });
      return;
    }

    const token = generateToken(agency._id.toString());

    res.status(200).json({ message: "Login successful", token });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

export { agencyRouter };
