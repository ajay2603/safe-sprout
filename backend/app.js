const express = require("express");
const app = express();
const mongoose = require("mongoose");
require("dotenv").config();

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

const clearSocketData = require("./utilities/clearsocketdata");

mongoose.connect(process.env.DB_CONNECTOR).then((_) => {
  clearSocketData();
});

const userAuthRoutes = require("./routes/auth");
app.use("/user/auth", userAuthRoutes);

const childRoutes = require("./routes/child");
app.use("/child", childRoutes);

const userRoutes = require("./routes/user");
app.use("/user", userRoutes);

const http = require("http");
const server = http.createServer(app);
const socketIO = require("socket.io");
const IO = socketIO(server);
const { initIO } = require("./sockets/socket");
initIO(IO);

const PORT = process.env.PORT || 4000;
server.listen(PORT, () => console.log("Server running on port: " + PORT));
