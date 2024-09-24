import { Router } from 'express';
import { signup, login } from '../controllers/authController.js'; 
import User from '../models/user.js';
import Message from '../models/message.js';  

const router = Router();

// POST /signup
router.post('/signup', signup);

// POST /login
router.post('/login', login);

// New route to fetch all users
router.get('/users', async (req, res) => {
    try {
      const users = await User.find({}, 'username email'); // Fetch only username and email
      res.json(users);
    } catch (error) {
      console.error('Error fetching users:', error); // Log the error
      res.status(500).json({ error: 'Failed to fetch users', details: error.message });
    }
});

// Route to fetch messages between sender and receiver
router.get('/messages/:senderId/:receiverId', async (req, res) => {
    const { senderId, receiverId } = req.params;
    
    try {
      const messages = await Message.find({
        $or: [
          { sender: senderId, receiver: receiverId },
          { sender: receiverId, receiver: senderId },
        ],
      }).sort({ createdAt: 1 }); // Sort messages by timestamp
  
      res.json(messages);
    } catch (error) {
      console.error('Error fetching messages:', error);
      res.status(500).json({ error: 'Failed to fetch messages' });
    }
});

export default router;
