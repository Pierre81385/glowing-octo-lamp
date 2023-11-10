const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const dotenv = require("dotenv");
const http = require("http"); // Require the http module
const socketIo = require("socket.io"); // Require the socket.io module

dotenv.config();

const app = express();
const port = process.env.PORT || 3001;
app.use(cors());
app.use(express.json());

const server = http.createServer(app); // Create an HTTP server
const io = socketIo(server, {
  cors: {
    origin: [process.env.BASEURL],
    methods: ["GET", "POST", "PUT", "DELETE"],
  },
}); // Initialize Socket.IO with the server

const UserRouter = require("./routes/UsersRoutes");

app.use("/users", UserRouter);

const uri = process.env.ATLAS_URI;
mongoose.connect(uri, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});
const connection = mongoose.connection;
connection.once("open", () => {
  console.log("MongoDB database connection established successfully");
});

const online = [];
// Socket.IO setup
io.on("connection", (socket) => {
  console.log("a user connected");

  //notify of user login
  //   socket.on("Login", function (data) {
  //     console.log("a user logged on");
  //     online.push(data.username);
  //     io.emit("Notify_Login", online);
  //   });

  //   //notify of user logout
  //   socket.on("Logout", function (data) {
  //     console.log("a user logged off");
  //     const index = online.indexOf(data.username);
  //     if (index > -1) {
  //       online.splice(index, 1);
  //     }
  //     io.emit("Notify_Logout", online);
  //   });

  socket.on("disconnect", (data) => {
    console.log("user disconnected");
  });
});

app.use(
  cors({
    origin: [`${process.env.BASEURL}:${port}`],
    methods: ["GET", "POST", "PUT", "DELETE"],
    credentials: true,
  })
);

server.listen(port, () => {
  console.log(`Server is running on port: ${port}`);
});
