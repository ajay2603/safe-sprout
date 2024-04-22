const express = require("express");
const app = express();
const mongoose = require("mongoose");
require("dotenv").config();

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

mongoose.connect(
  "mongodb://127.0.0.1:27017/safeSproutDB?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.0.1"
);

const userRoutes = require("./routes/auth");
app.use("/user/auth", userRoutes);

const childRoutes = require("./routes/child");
app.use("/child", childRoutes);

const http = require("http");
const server = http.createServer(app);
const socketIO = require("socket.io");
const IO = socketIO(server);
const { initIO } = require("./sockets/socket");
initIO(IO);

const PORT = 4000;
server.listen(PORT, () => console.log("Server running on port: " + PORT));