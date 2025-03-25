import jwt from 'jsonwebtoken';
import bcrypt from 'bcrypt';
import User from '../models/user.js';
import dotenv from 'dotenv';

dotenv.config();

// Define the signup function
export const signup = async (req, res) => {
  const { username, password, email, firstName, lastName, gender } = req.body;

  try {
    // Input validation
    if (!username || !password || !email || !firstName || !lastName || !gender) {
      return res.status(400).json({ error: 'All fields are required' });
    }

    // Check for existing user by username
    const existingUser = await User.findOne({ username });
    if (existingUser) {
      return res.status(400).json({ error: 'Username already exists' });
    }

    // Check for existing user by email
    const existingEmail = await User.findOne({ email });
    if (existingEmail) {
      return res.status(400).json({ error: 'Email already exists' });
    }

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create new user
    const newUser = new User({
      username,
      password: hashedPassword,
      email,
      firstName,
      lastName,
      gender
    });

    // Generate JWT token
    const token = jwt.sign({ userId: newUser._id }, process.env.JWT_SECRET);

    await newUser.save();
    res.status(201).json({status: "SUCCESS", message: 'User created successfully' ,
       data:{ userId: newUser._id, username: newUser.username,
         email: newUser.email, firstName: newUser.firstName,
          lastName: newUser.lastName, gender: newUser.gender ,token: token}});
  } catch (error) {
    console.error('Error creating user:', error.message);
    res.status(500).json({ error: 'Error creating user' });
  }
};

// Define the login function
export const login = async (req, res) => {
  try {
    const { username, password } = req.body;

    // Input validation
    if (!username || !password) {
      return res.status(400).json({ error: 'Username and password are required' });
    }

    const user = await User.findOne({ username });

    // Validate user credentials
    if (!user || !(await bcrypt.compare(password, user.password))) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    // Generate JWT token
    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET);

    // Return token and user ID
    res.status(200).json({ status: "SUCCESS",message: "User logged In successfully",  
      data:{ userId: user._id, username: user.username,
      email: user.email, firstName: user.firstName,
       lastName: user.lastName, gender: user.gender , token: token}});
  } catch (error) {
    console.error('Login failed:', error.message);
    res.status(500).json({ error: 'Login failed' });
  }
};
