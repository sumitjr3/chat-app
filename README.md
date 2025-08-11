# Chat Application

This is a full-stack chat application built with a Flutter frontend and a Node.js backend. It uses Socket.IO for real-time communication, allowing users to send and receive messages instantly.

![alt text](<Frame 5.png>)

## Features

- User authentication (signup and login)
- Real-time one-to-one chat
- View a list of users you have chatted with
- User profiles with avatars
- Responsive design for different screen sizes

## Technologies Used

### Frontend (Flutter)

- **Framework:** Flutter
- **State Management:** GetX
- **HTTP Client:** http
- **Real-time Communication:** socket_io_client
- **Local Storage:** shared_preferences
- **Environment Variables:** flutter_dotenv
- **Vector Graphics:** flutter_svg

### Backend (Node.js)

- **Framework:** Express.js
- **Database:** MongoDB (with Mongoose)
- **Real-time Communication:** Socket.IO
- **Authentication:** JSON Web Tokens (JWT)
- **Password Hashing:** bcrypt.js
- **Environment Variables:** dotenv

## Project Structure

The project is divided into two main parts:

- `chat_application_socket_io/`: The Flutter frontend application.
- `chat server/`: The Node.js backend server.

## Prerequisites

- Node.js and npm installed
- Flutter SDK installed
- MongoDB instance (local or cloud)

## Getting Started

### Backend Setup

1.  Navigate to the `chat server` directory:
    ```bash
    cd "chat server"
    ```
2.  Install the dependencies:
    ```bash
    npm install
    ```
3.  Create a `.env` file in the `chat server` directory and add the following environment variables:
    ```
    MONGO_URI=<your_mongodb_connection_string>
    PORT=5000
    JWT_SECRET=<your_jwt_secret>
    ```
4.  Start the backend server:
    ```bash
    npm start
    ```

### Frontend Setup

1.  Navigate to the `chat_application_socket_io` directory:
    ```bash
    cd chat_application_socket_io
    ```
2.  Install the dependencies:
    ```bash
    flutter pub get
    ```
3.  Create a `.envApp` file in the `chat_application_socket_io` directory and add the following environment variable:

    ```
    API_URL=<your_backend_api_url>
    ```

    (e.g., `API_URL=http://localhost:5000`)

4.  Run the application:
    ```bash
    flutter run
    ```

## API Endpoints

The backend exposes the following REST API endpoints:

- `POST /auth/register`: Register a new user.
- `POST /auth/login`: Log in an existing user.
- `GET /user/`: Get all users.
- `GET /chat/:receiverId`: Get chat messages with a specific user.
- `POST /chat/`: Send a new message.

## Socket.IO Events

The application uses Socket.IO for real-time features. The key events are:

- `connection`: When a user connects to the server.
- `sendMessage`: When a user sends a message.
- `receiveMessage`: When a user receives a message.
- `chatList`: To get the list of chats for a user.
- `disconnect`: When a user disconnects.
