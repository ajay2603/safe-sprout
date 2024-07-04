const jwt = require("jsonwebtoken");
const childSocket = require("./childsocket");
const parentSocket = require("./parentSocket");
const Child = require("../database/child_model");
var IO;
let socket;

const getPayLode = (token) => {
  try {
    const paylode = jwt.verify(token, process.env.JWT_SECRET);
    return paylode;
  } catch (err) {
    throw new Error("invalid token");
  }
};

const initIO = (Io) => {
  IO = Io;
  Io.use((socket, next) => {
    try {
      const token = socket.handshake.headers.authorization;
      const paylode = getPayLode(token);
      if (paylode) {
        next();
      } else {
        next(Error("null paylode"));
      }
    } catch (err) {
      console.error(err);
      next(Error(err));
    }
  });
  Io.on("connect", (socket) => {
    this.socket = socket;

    console.log("connected");
    socket.on("disconnect", () => {
      console.log("disconnect");
    });

    try {
      const paylode = getPayLode(socket.handshake.headers.authorization);
      if (paylode.type == "child") {
        childSocket(socket, paylode, Io);
      } else if (paylode.type == "parent") {
        parentSocket(socket, paylode, Io);
      } else {
        console.log(paylode);
      }
    } catch (err) {
      console.error(err);
      socket.disconnect();
    }

    setInterval(() => {
      socket.emit("event", "listned event ");
    }, 1000);
  });
};

module.exports = { initIO, getIO: () => IO, getSocket: () => socket };
