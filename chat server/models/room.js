// models/room.js
import mongoose from 'mongoose';

const roomSchema = new mongoose.Schema({
  users: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  }],
  roomID: {
    type: String,
    required: true,
    unique: true,
  },
  last_updated: {
    type: Date,
    default: Date.now,
  },
  last_message: {
    type: String,
    default: '',
  },
});

const Room = mongoose.model('Room', roomSchema);

export default Room;