// models/user.js

import mongoose from 'mongoose';

const userSchema = new mongoose.Schema({
  username: { type: String, required: true },
  password: { type: String, required: true },
  email: {
    type: String,
    required: true,
    unique: true, // Ensure that email is unique
  },
});

// Make sure you are exporting 'User' as the default
const User = mongoose.model('User', userSchema);

export default User;
