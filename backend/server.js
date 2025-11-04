import express from "express";
import dotenv from "dotenv";
import cors from "cors";
import connectDB from "./config/db.js";
import authRoutes from "./routes/auth.js";

dotenv.config(); // .env файлын жүктеу

const app = express();
app.use(cors());
app.use(express.json());

// 🧭 Routes
app.use("/api/auth", authRoutes);

// 🌐 MongoDB Atlas-пен байланыс
connectDB();

// 🚀 Серверді іске қосу
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`🚀 Server running on port ${PORT}`));
