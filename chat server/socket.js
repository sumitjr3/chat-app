import { Server as SocketIO } from 'socket.io';
import Message from './models/message.js';

export const initSocket = (server) => {
  const io = new SocketIO(server, {
    cors: {
      origin: '*', // Adjust this to your frontend URL in production
      methods: ['GET', 'POST'],
    }
  });

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
    });

    // Rejoin a room
    socket.on('rejoinRoom', ({ roomID }) => {
      if (!roomID) {
        console.error('Room ID is missing');
        return;
      }

      // Rejoin the room
      socket.join(roomID);
      console.log(`User rejoined room: ${roomID}`);
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
        console.log(`Message sent to room: ${roomID}`);
      } catch (err) {
        console.error('Error saving message to database:', err);
      }
    });

    // Handle disconnect
    socket.on('disconnect', () => {
      console.log('Client disconnected:', socket.id);
    });
  });
};
