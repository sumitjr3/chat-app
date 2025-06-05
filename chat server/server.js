import express, { json } from "express";
import { createServer } from "http";
import cors from "cors";
import authRoutes from "./routes/authRoutes.js";
import chatRoutes from "./routes/chatRoutes.js";
import userRoutes from "./routes/userRoutes.js";
import dotenv from "dotenv";
import pkg from "mongoose";
const { connect } = pkg;
import { Server as SocketIO } from "socket.io"; // Make sure Server is imported

import initializeSocketChatList from "./chatListSocket.js";
import initializeSocket from "./socket.js";
dotenv.config();

// Initialize Express app
const app = express();
const server = createServer(app);

// CORS configuration - Allow all origins
const corsOptions = {
  origin: "*", // Allow all origins
  credentials: false, // Set to false when using "*" origin
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"],
};

// Middleware
app.use(cors(corsOptions));
app.use(json());

// Security headers
app.use((req, res, next) => {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  next();
});

app.use("/auth", authRoutes);
app.use("/chat", chatRoutes);
app.use("/user", userRoutes);

// Connect to MongoDB
connect(process.env.MONGO_URI)
  .then(() => console.log("MongoDB connected"))
  .catch((err) => console.log("MongoDB connection error:", err));

const io = new SocketIO(server, {
  // Create ONE main io instance
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
  },
});
// Initialize Socket.IO
initializeSocket(io);
initializeSocketChatList(io);

// Start server
const PORT = process.env.PORT || 5000;
server.listen(PORT, (err) => {
  if (err) {
    console.error("Error starting server:", err);
    process.exit(1);
  }
  console.log(`Server running on port ${PORT}`);
});

// Handle graceful shutdown
process.on("SIGTERM", () => {
  console.info("SIGTERM signal received. Closing server...");
  server.close(() => {
    console.log("Server closed");
    process.exit(0);
  });
});
