const initializeSocketChatList = (io) => {
  const chatListNamespace = io.of("/chatlist/");

  chatListNamespace.on("connection", (socket) => {
    console.log("chatlist----------------->New client connected:", socket.id);

    socket.on("joinRoom", async ({ userId }) => {
      if (!userId) {
        console.error("chatlist-----------------> User ID is missing");
        return;
      }

      try {
        socket.join(userId);
        console.log(
          `chatlist----------------->User joined room chatlist ${userId} `
        );
      } catch (err) {
        console.error("chatlist----------------->Error joining room:", err);
        socket.emit("error", {
          message:
            "chatlist----------------->Failed to join room. Please try again.",
        });
      }
    });

    socket.on("leaveRoom", ({ userId }) => {
      if (!userId) {
        console.error(
          "chatlist----------------->Room ID or User ID is missing"
        );
        return;
      }
      socket.leave(userId);
      console.log(
        `chatlist----------------->User left chatlist room  ${userId}`
      );
    });

    socket.on("rejoinRoom", ({ userId }) => {
      if (!userId) {
        console.error("chatlist----------------->user ID is missing");
        return;
      }
      socket.join(userId);
      console.log(`chatlist----------------->User rejoined room: ${userId}`);
    });

    socket.on("sendMessage", async ({ userId }) => {
      if (!userId) {
        console.error("chatlist----------------->Incomplete message data:");
        return;
      }
      try {
        chatListNamespace.to(userId).emit("updateChatList");
        console.log("chatlist----------------->message sent to " + userId);
      } catch (err) {
        console.error(
          "chatlist----------------->Error saving message to database:",
          err
        );
        socket.emit("error", {
          message: "Failed to send message. Please try again.",
        });
      }
    });

    // socket.on("typing", ({ userId, typingUserId }) => {
    //   if (!typingUserId || !userId) {
    //     console.error("chatlist----------------->Incomplete typing data:", {
    //       typingUserId,
    //       userId,
    //     });
    //     return;
    //   }
    //   socket.to(userId).emit("typing", typingUserId);
    // });

    // socket.on("stop_typing", ({ userId, typingUserId }) => {
    //   if (!typingUserId || !userId) {
    //     console.error(
    //       "chatlist----------------->Incomplete stop_typing data:",
    //       { typingUserId, userId }
    //     );
    //     return;
    //   }
    //   socket.to(userId).emit("stop_typing", typingUserId);
    // });

    socket.on("disconnect", ({ userId }) => {
      if (userId) {
        chatListNamespace.emit("user_offline", userId);
      }
      console.log("Client disconnected:", socket.id);
    });
  });
};

export default initializeSocketChatList;
