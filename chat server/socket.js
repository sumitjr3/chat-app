import { Server as SocketIO } from "socket.io";
import Message from "./models/message.js";
import Room from "./models/room.js";

// Use a Map for efficient user management
let onlineUsers = new Map();

const initializeSocket = (server) => {
  const io = new SocketIO(server, {
    transports: ["websocket", "polling"],
    cors: {
      origin: "*",
      methods: ["GET", "POST"],
    },
  });

  io.on("connection", (socket) => {
    console.log("New client connected:", socket.id);

    socket.on("joinRoom", async ({ roomID, userId }) => {
      if (!roomID || !userId) {
        console.error("Room ID or User ID is missing");
        return;
      }

      try {
        const [user1Id, user2Id] = roomID.split("-");

        const istTime = new Date().toLocaleString("en-US", {
          timeZone: "Asia/Kolkata",
          hour12: false,
          iso: "extended",
        });
        // const istTimeFormatted = new Date(istTime).toISOString();

        // Use findOneAndUpdate with upsert to simplify room creation/update logic
        // const room = await Room.findOneAndUpdate(
        //   { roomID },
        //   { $addToSet: { users: [user1Id, user2Id] } },
        //   { upsert: true, new: true }
        // );

        socket.join(roomID);
        onlineUsers.set(userId, socket.id);
        io.to(roomID).emit("total_clients", onlineUsers.size);
        console.log(`User ${userId} joined room: ${roomID}`);
      } catch (err) {
        console.error("Error joining room:", err);
        socket.emit("error", {
          message: "Failed to join room. Please try again.",
        });
      }
    });

    socket.on("leaveRoom", ({ roomID, userId }) => {
      if (!roomID || !userId) {
        console.error("Room ID or User ID is missing");
        return;
      }
      socket.leave(roomID);
      onlineUsers.delete(userId);
      io.to(roomID).emit("total_clients", onlineUsers.size);
      console.log(`User ${userId} left room: ${roomID}`);
    });

    socket.on("rejoinRoom", ({ roomID }) => {
      if (!roomID) {
        console.error("Room ID is missing");
        return;
      }
      socket.join(roomID);
      console.log(`User rejoined room: ${roomID}`);
    });

    socket.on("sendMessage", async (data) => {
      const { sender, receiver, content, roomID } = data;
      if (!roomID || !sender || !receiver || !content) {
        console.error("Incomplete message data:", data);
        return;
      }
      try {
        const istTime = new Date().toLocaleString("en-US", {
          timeZone: "Asia/Kolkata",
          hour12: false,
          iso: "extended",
        });

        const istTimeFormatted = new Date(istTime).toISOString();

        const message = new Message({
          sender,
          receiver,
          content,
          roomID,
          createdAt: new Date(istTimeFormatted),
        });
        await message.save();

        // Update the room's last_updated and last_message fields

        await Room.findOneAndUpdate(
          { roomID },
          {
            $addToSet: { users: [sender, receiver] },
            last_updated: istTimeFormatted,
            last_message: content,
          },
          { upsert: true, new: true }
        );

        io.to(roomID).emit("message", { ...data, timestamp: istTime });
      } catch (err) {
        console.error("Error saving message to database:", err);
        socket.emit("error", {
          message: "Failed to send message. Please try again.",
        });
      }
    });

    socket.on("typing", ({ roomID, userId }) => {
      if (!roomID || !userId) {
        console.error("Incomplete typing data:", { roomID, userId });
        return;
      }
      socket.to(roomID).emit("typing", userId);
    });

    socket.on("stop_typing", ({ roomID, userId }) => {
      if (!roomID || !userId) {
        console.error("Incomplete stop_typing data:", { roomID, userId });
        return;
      }
      socket.to(roomID).emit("stop_typing", userId);
    });

    socket.on("disconnect", () => {
      const userId = Array.from(onlineUsers.keys()).find(
        (key) => onlineUsers.get(key) === socket.id
      );
      if (userId) {
        onlineUsers.delete(userId);
        io.emit("user_offline", userId);
      }
      console.log("Client disconnected:", socket.id);
    });
  });
};

export default initializeSocket;
