// models/message.js

import mongoose from 'mongoose';

  const messageSchema = new mongoose.Schema({
    sender: { type: mongoose.Schema.Types.ObjectId, required: true },
    receiver: { type: mongoose.Schema.Types.ObjectId, required: true },
    content: { type: String, required: true },
    roomID: { type: String, required: true },
  }, { timestamps: true });


const Message = mongoose.model('Message', messageSchema);

export default Message;
