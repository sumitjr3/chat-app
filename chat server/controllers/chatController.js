const Message = require('../models/message');
const Room = require('../models/room');

const fetchMessages = async (req, res) => {
  const { roomID } = req.params;

  const messages = await Message.find({ roomID }).populate('sender receiver');
  res.status(200).json(messages);
};

module.exports = { fetchMessages };
