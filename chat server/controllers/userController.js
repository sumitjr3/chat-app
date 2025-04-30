import jwt from "jsonwebtoken";
import User from "../models/user.js";
import Room from "../models/room.js"; // Import Room model
import Users from "../models/user.js"; // Import Users model
import dotenv from "dotenv";

dotenv.config();

// Define the findUser function
export const findUser = async (req, res) => {
  const { username } = req.body; // Extract username from body
  const token = req.headers.authorization?.split(" ")[1];

  try {
    // Check if token is provided
    if (!token) {
      return res
        .status(401)
        .json({ status: "FAIL", error: "Token is required" });
    }

    // Verify token
    let decoded;
    try {
      decoded = jwt.verify(token, process.env.JWT_SECRET);
    } catch (err) {
      return res
        .status(401)
        .json({ status: "FAIL", error: "Token is invalid" });
    }

    // Input validation
    if (!username) {
      return res
        .status(400)
        .json({ status: "FAIL", error: "Username is required" });
    }

    // Find user by username
    const user = await User.findOne({ username }).select("-password");

    if (!user) {
      return res.status(200).json({ status: "FAIL", error: "User not found" });
    }

    // Return user details
    res.status(200).json({ status: "SUCCESS", data: user });
  } catch (error) {
    console.error("Error finding user:", error.message);
    res.status(500).json({ status: "FAIL", error: "Error finding user" });
  }
};

export const getChatList = async (req, res) => {
  const token = req.headers.authorization?.split(" ")[1];
  const userId = req.body.userId; // Extract userId from body

  console.log("Fetching user rooms for...", userId);
  try {
    // Check if token is provided
    if (!token) {
      return res
        .status(401)
        .json({ status: "FAIL", data: { message: "Token is required" } });
    }

    // Verify token
    let decoded;
    try {
      decoded = jwt.verify(token, process.env.JWT_SECRET);
    } catch (err) {
      return res
        .status(401)
        .json({ status: "FAIL", data: { message: "Token is invalid" } });
    }

    if (!userId) {
      return res
        .status(400)
        .json({ status: "FAIL", data: { message: "User not authenticated." } });
    }

    const userRooms = await Room.find({ users: userId });

    if (userRooms.length === 0) {
      return res.status(200).json({
        status: "SUCCESS",
        length: 0,
        data: { message: "No rooms found for the user." },
      });
    }

    const roomsWithOtherUsers = []; // Create a new array

    // Iterate over userRooms and populate otherPerson for each room with the other user's details (email, phone, username)
    for (const room of userRooms) {
      // Use for...of for cleaner iteration
      const otherUser = room.users.find(
        (id) => id.toString() !== userId.toString()
      );

      if (otherUser) {
        // Check if otherUser exists
        const otherPerson = await Users.findOne(otherUser).select(
          "email phone username gender avatar"
        );

        // Convert Mongoose document to a plain JavaScript object
        const roomObject = room.toObject();

        roomObject.otherPerson = otherPerson;
        roomsWithOtherUsers.push(roomObject);
      } else {
        // Handle the case where there's no other user (e.g., group chat with only the current user)
        const roomObject = room.toObject();
        roomObject.otherPerson = null; // Or some other appropriate value
        roomObject.otherUser = null;
        roomsWithOtherUsers.push(roomObject);
      }
    }

    res.status(200).json({
      status: "SUCCESS",
      length: roomsWithOtherUsers.length,
      data: roomsWithOtherUsers,
    });
  } catch (err) {
    console.error("Error fetching user rooms:", err);
    res.status(500).json({
      status: "FAIL",
      data: { message: "Failed to fetch user rooms." },
    });
  }
};
