// import express, { json } from 'express';
// import { createServer } from 'http';
// import { Server as SocketIO } from 'socket.io';
// import authRoutes from './routes/auth.js';
// import chatRoutes from './routes/chat.js';
// import Message from './models/message.js'; 
// import pkg from 'mongoose'; 
// const { connect } = pkg;
// import dotenv from 'dotenv';

// dotenv.config();

// // Initialize Express app and Socket.IO server
// const app = express();
// const server = createServer(app);
// const io = new SocketIO(server, {
//   cors: {
//     origin: '*', // Adjust this to your frontend URL in production
//     methods: ['GET', 'POST'],
//   }
// });

// // Middleware
// app.use(json());
// app.use('/auth', authRoutes);
// app.use('/chat', chatRoutes);

// // Connect to MongoDB
// connect(process.env.MONGO_URI)
//   .then(() => console.log('MongoDB connected'))
//   .catch(err => console.log('MongoDB connection error:', err));

// // Socket.IO events
// io.on('connection', (socket) => {
//   console.log('New client connected:', socket.id);

//   // Join a room
//   socket.on('joinRoom', ({ roomID }) => {
//     if (!roomID) {
//       console.error('Room ID is missing');
//       return;
//     }

//     // Join the room
//     socket.join(roomID);
//     console.log(`User joined room: ${roomID}`);
//   });

//   // Listen for new messages
//   socket.on('sendMessage', async (data) => {
//     const { sender, receiver, content, roomID } = data;

//     // Validate message data
//     if (!roomID || !sender || !receiver || !content) {
//       console.error('Incomplete message data:', data);
//       return;
//     }

//     try {
//       // Save the message in the database
//       const message = new Message({ sender, receiver, content, roomID });
//       await message.save();

//       // Emit the message to the receiver's room
//       io.to(roomID).emit('message', data);
//     } catch (err) {
//       console.error('Error saving message to database:', err);
//     }
//   });

//   // Handle disconnect
//   socket.on('disconnect', () => {
//     console.log('Client disconnected:', socket.id);
//   });
// });

// // Start server
// const PORT = process.env.PORT || 5000;
// server.listen(PORT, () => {
//   console.log(`Server running on port ${PORT}`);
// });


//new code 
import express, { json } from 'express';
import { createServer } from 'http';
import { Server as SocketIO } from 'socket.io';
import authRoutes from './routes/auth.js';
import chatRoutes from './routes/chat.js';
import Message from './models/message.js'; 
import pkg from 'mongoose'; 
const { connect } = pkg;
import dotenv from 'dotenv';

dotenv.config();

// Initialize Express app and Socket.IO server
const app = express();
const server = createServer(app);
const io = new SocketIO(server, {
  cors: {
    origin: '*', // Adjust this to your frontend URL in production
    methods: ['GET', 'POST'],
  }
});

// Middleware
app.use(json());
app.use('/auth', authRoutes);
app.use('/chat', chatRoutes);

// Connect to MongoDB
connect(process.env.MONGO_URI)
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.log('MongoDB connection error:', err));

// Socket.IO events
io.on('connection', (socket) => {
  console.log('New client connected:', socket.id);

  // Join a room
  socket.on('joinRoom', ({ roomID }) => {
    if (!roomID) {
      console.error('Room ID is missing');
      return;
    }

    // Join the room
    socket.join(roomID);
    console.log(`User joined room: ${roomID}`);
  });

  // Leave a room
  socket.on('leaveRoom', ({ roomID }) => {
    
    if (!roomID) {
      console.error('Room ID is missing');
      return;
    }

    // Leave the room
    socket.leave(roomID);
    console.log(`User left room: ${roomID}`); 

     // Add rejoin logic here
  socket.on('rejoinRoom', ({ roomID }) => {
    // Rejoin the room
    socket.join(roomID);
    console.log(`User rejoined room: ${roomID}`);
  });
  });

  // Listen for new messages
  socket.on('sendMessage', async (data) => {
    const { sender, receiver, content, roomID } = data;

    // Validate message data
    if (!roomID || !sender || !receiver || !content) {
      console.error('Incomplete message data:', data);
      return;
    }

    try {
      // Save the message in the database
      const message = new Message({ sender, receiver, content, roomID });
      await message.save();

      // Emit the message to the receiver's room
      io.to(roomID).emit('message', data);
    } catch (err) {
      console.error('Error saving message to database:', err);
    }
  });

  // Handle disconnect
  socket.on('disconnect', () => {
    console.log('Client disconnected:', socket.id);
  });
});

// Start server
const PORT = process.env.PORT || 5000;
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
