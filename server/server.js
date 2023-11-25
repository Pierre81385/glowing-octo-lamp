const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const dotenv = require("dotenv");
const http = require("http"); // Require the http module
const socketIo = require("socket.io"); // Require the socket.io module

dotenv.config();
//test s3 connection
const AWS = require("aws-sdk");

const s3 = new AWS.S3({
  accessKeyId: process.env.AWS_ACCESS_KEY_ID,
  secretAccessKey: process.env.AWS_SECRET_KEY,
});
const BUCKET = process.env.AWS_BUCKET_NAME;

var params = {
  Bucket: BUCKET,
  MaxKeys: 2,
};
s3.listObjects(params, function (err, data) {
  if (err) console.log(err, err.stack); // an error occurred
  else console.log(data); // successful response
});
//test of s3 connection completed

const app = express();
const port = process.env.PORT || 3001;
app.use(cors());
app.use(
  express.json({
    verify: (req, res, buf) => {
      req.rawBody = buf.toString();
    },
    limit: "50 mb",
  })
);
app.use(express.urlencoded({ extended: true, limit: "50 mb" }));

const server = http.createServer(app); // Create an HTTP server
const io = socketIo(server, {
  cors: {
    origin: [process.env.BASEURL],
    methods: ["GET", "POST", "PUT", "DELETE"],
  },
}); // Initialize Socket.IO with the server

const UserRouter = require("./routes/UsersRoutes");
const ProductRouter = require("./routes/ProductRoutes");
const OrderRouter = require("./routes/OrderRoutes");
const AWSRouter = require("./routes/AWSRoutes");

app.use("/users", UserRouter);
app.use("/products", ProductRouter);
app.use("/orders", OrderRouter);
app.use("/aws", AWSRouter);

const uri = process.env.ATLAS_URI;
mongoose.connect(uri, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});
const connection = mongoose.connection;
connection.once("open", () => {
  console.log("MongoDB database connection established successfully");
});

// Socket.IO setup
io.on("connection", (socket) => {
  console.log("a user connected");

  //notify of user login
  socket.on("login", function (data) {
    console.log(`${data["user"]["firstName"]} logged on.`);
    io.emit("notify_login", data);
  });

  //notify update required to product lists
  socket.on("product_update_successful", function (data) {
    console.log(data.message);
    io.emit("update_product_list", data);
  });

  //notify update required to product lists
  socket.on("product_deleted", function (data) {
    console.log(data.message);
    io.emit("update_product_list", data);
  });

  //notifiy update required to users lists
  socket.on("user_update_successful", function (data) {
    console.log(data.message);
    io.emit("update_users_list", data);
  });

  //notifiy update required to users lists
  socket.on("user_deleted", function (data) {
    console.log(data.message);
    io.emit("update_users_list", data);
  });

  //notifiy update required to users lists
  socket.on("order_deleted", function (data) {
    console.log(data.message);
    io.emit("update_orders_list", data);
  });

  io.on("disconnect", (data) => {
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
