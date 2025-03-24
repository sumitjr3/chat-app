import mongoose from 'mongoose';

const messageSchema = new mongoose.Schema({
    sender: { type: mongoose.Schema.Types.ObjectId, required: true },
    receiver: { type: mongoose.Schema.Types.ObjectId, required: true },
    content: { type: String, required: true },
    roomID: { type: String, required: true },
    createdAt: {
      type: Date,
      default: () => {
        return new Date().toLocaleString('en-US', {
          timeZone: 'Asia/Kolkata',
          hour12: false
        });
      }
    }
  }, { timestamps: true });

 
const Message =  mongoose.model('Message', messageSchema);

export default Message;
 