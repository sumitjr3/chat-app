// routes/chat.js

import express from 'express';
import Message from '../models/message.js';

const router = express.Router();

// Define your chat routes
router.post('/send', (req, res) => {
  // Handle sending messages
  res.send('Message sent');
});

// Add other chat routes as needed
router.get('/messages/:roomID', async (req, res) => {
  try {
    const { roomID } = req.params;
    const messages = await Message.find({ roomID });
    res.json(messages);
  } catch (error) {
    console.error('Error fetching messages:', error);
    res.status(500).send('Server error');
  }
});

// Export the router as default
export default router;
