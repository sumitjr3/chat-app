import { Server as SocketIO } from "socket.io";
import Message from "./models/message.js";
import Room from "./models/room.js";

// Use a Map for efficient user management
let onlineUsers = new Map();

const initializeSocket = (io) => {
  // Set up CORS and other socket.io configurations
  io.engine.on("connection_error", (err) => {
    console.log("Connection error:", err);
  });

  io.on("connection", (socket) => {
    console.log("New client connected:", socket.id);

    // Handle connection errors
    socket.on("error", (error) => {
      console.error("Socket error:", error);
    });

    socket.on("joinRoom", async ({ roomID, userId }) => {
      if (!roomID || !userId) {
        console.error("Room ID or User ID is missing");
        socket.emit("error", { message: "Room ID and User ID are required" });
        return;
      }

      try {
        const [user1Id, user2Id] = roomID.split("-");
        
        // Get IST time
        const istTime = new Date().toLocaleString("en-US", {
          timeZone: "Asia/Kolkata",
          hour12: false,
        });

        // Join room and update online users
        socket.join(roomID);
        onlineUsers.set(userId, {
          socketId: socket.id,
          roomID,
          lastActive: new Date(),
        });

        // Notify room members
        io.to(roomID).emit("total_clients", {
          count: io.sockets.adapter.rooms.get(roomID)?.size || 0,
          onlineUsers: Array.from(onlineUsers.keys()),
        });

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
      handleUserLeaving(socket, roomID, userId);
    });

    socket.on("sendMessage", async (data) => {
      const { sender, receiver, content, roomID } = data;
      if (!roomID || !sender || !receiver || !content) {
        console.error("Incomplete message data:", data);
        socket.emit("error", { message: "Incomplete message data" });
        return;
      }

      try {
        const istTime = new Date().toLocaleString("en-US", {
          timeZone: "Asia/Kolkata",
          hour12: false,
        });

        const message = new Message({
          sender,
          receiver,
          content,
          roomID,
          createdAt: new Date(istTime),
        });
        await message.save();

        // Update room in a single operation
        await Room.findOneAndUpdate(
          { roomID },
          {
            $addToSet: { users: [sender, receiver] },
            $set: {
              last_updated: istTime,
              last_message: content,
            }
          },
          { upsert: true, new: true }
        );

        io.to(roomID).emit("message", {
          ...data,
          timestamp: istTime,
          status: "delivered",
        });
      } catch (err) {
        console.error("Error saving message:", err);
        socket.emit("error", {
          message: "Failed to send message. Please try again.",
        });
      }
    });

    socket.on("typing", ({ roomID, userId }) => {
      if (!roomID || !userId) return;
      socket.to(roomID).emit("typing", userId);
    });

    socket.on("stop_typing", ({ roomID, userId }) => {
      if (!roomID || !userId) return;
      socket.to(roomID).emit("stop_typing", userId);
    });

    socket.on("disconnect", () => {
      const userId = Array.from(onlineUsers.entries())
        .find(([_, data]) => data.socketId === socket.id)?.[0];
      
      if (userId) {
        const userData = onlineUsers.get(userId);
        if (userData?.roomID) {
          handleUserLeaving(socket, userData.roomID, userId);
        }
      }
    });
  });
};

function handleUserLeaving(socket, roomID, userId) {
  socket.leave(roomID);
  onlineUsers.delete(userId);
  
  // Notify room about user leaving
  socket.to(roomID).emit("total_clients", {
    count: (socket.adapter.rooms.get(roomID)?.size || 0) - 1,
    onlineUsers: Array.from(onlineUsers.keys()),
  });
  
  socket.to(roomID).emit("user_offline", userId);
  console.log(`User ${userId} left room: ${roomID}`);
}

export default initializeSocket;
