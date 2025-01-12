import pkg from 'jsonwebtoken';
const { sign } = pkg;
import User from '../models/user.js';

// Define the signup function
export const signup = async (req, res) => {
  const { username, password } = req.body; // Ensure email is included

  try {
    // Check for existing user by username
    const existingUser = await User.findOne({ username });
    if (existingUser) {
      return res.status(400).json({ error: 'Username already exists' });
    }

    // Check for existing user by email
    const existingEmail = await User.findOne({ username });
    if (existingEmail) {
      return res.status(400).json({ error: 'username already exists' });
    }

    // Create new user
    const newUser = new User({ username, password });
    await newUser.save();
    res.status(201).json({ message: 'User created successfully' });
  } catch (error) {
    console.error('Error creating user:', error.message);
    res.status(500).json({ error: 'Error creating user' });
  }
};

// Define the login function
export const login = async (req, res) => {
  try {
    const { username, password } = req.body;
    const user = await User.findOne({ username });

    // Validate user credentials
    if (!user || user.password !== password) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    // Generate JWT token
    const token = sign({ userId: user._id }, 'your_jwt_secret', { expiresIn: '1h' });

    // Return token and user ID
    res.status(200).json({ token, userId: user._id }); // Include user ID in the response
  } catch (error) {
    console.error('Login failed:', error.message);
    res.status(500).json({ error: 'Login failed' });
  }
};
