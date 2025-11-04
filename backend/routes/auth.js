import express from "express";
import bcrypt from "bcryptjs";
import User from "../models/User.js";

const router = express.Router();

/**
 * 🧁 Signup (register)
 */
router.post("/signup", async (req, res) => {
  try {
    const { email, password, name } = req.body;

    // Email тексеру
    const existingUser = await User.findOne({ email });
    if (existingUser)
      return res.status(400).json({ message: "Бұл email бұрын тіркелген ❌" });

    // Password хэштеу
    const hashedPassword = await bcrypt.hash(password, 10);

    // Егер name бос болса — әдепкі "Қолданушы"
    const user = new User({
      name: name && name.trim() !== "" ? name : "Қолданушы",
      email,
      password: hashedPassword,
    });

    await user.save();
    res.status(200).json({ message: "Тіркелу сәтті өтті ✅" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Сервер қатесі 😢" });
  }
});

/**
 * 🍫 Login
 */
router.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    // Email тексеру
    const user = await User.findOne({ email });
    if (!user)
      return res
        .status(401)
        .json({ message: "Email немесе құпиясөз қате ❌" });

    // Password сәйкестігін тексеру
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch)
      return res
        .status(401)
        .json({ message: "Email немесе құпиясөз қате ❌" });

    res.status(200).json({ message: `Қош келдің, ${user.name}! 🎂` });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Сервер қатесі 😢" });
  }
});

export default router;
