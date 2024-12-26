const mongoose = require('mongoose');

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
});

module.exports = mongoose.model('Room', roomSchema);
