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
        // Get the current time as a Date object (represents a specific moment)
        const currentTime = new Date();

        // Format this time as an IST string for display purposes (e.g., sending to client)
        const istDisplayTime = currentTime.toLocaleString("en-US", {
          timeZone: "Asia/Kolkata",
          hour12: false,
        });

        const message = new Message({
          sender,
          receiver,
          content,
          roomID,
          createdAt: currentTime, // Store the Date object in the database
        });
        await message.save();

        await Room.findOneAndUpdate(
          { roomID },
          {
            $addToSet: { users: [sender, receiver] },
            $set: {
              last_updated: currentTime, // Store the Date object for last_updated (assuming it's a Date type in schema)
              last_message: content,
            },
          },
          { upsert: true, new: true }
        );

        io.to(roomID).emit("message", {
          ...data,
          timestamp: istDisplayTime, // Send the IST formatted string to the client
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
      const userId = Array.from(onlineUsers.entries()).find(
        ([_, data]) => data.socketId === socket.id
      )?.[0];

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
