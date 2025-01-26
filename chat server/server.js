import express, { json } from 'express';
import { createServer } from 'http';
import authRoutes from './routes/auth.js';
import chatRoutes from './routes/chat.js';
import dotenv from 'dotenv';
import pkg from 'mongoose';
const { connect } = pkg;
import { initSocket } from './socket.js'; // Import the Socket.IO initialization function

dotenv.config();

// Initialize Express app
const app = express();
const server = createServer(app);

// Middleware
app.use(json());
app.use('/auth', authRoutes);
app.use('/chat', chatRoutes);

// Connect to MongoDB
connect(process.env.MONGO_URI)
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.log('MongoDB connection error:', err));

// Initialize Socket.IO
initSocket(server);

// Start server
const PORT = process.env.PORT || 5000;
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
