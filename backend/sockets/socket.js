let IO;
let socket;
const initIO = (IO) => {
  this.IO = IO;
  IO.on("connect", (socket) => {
    this.socket = socket;
    console.log("connected");
    socket.on("disconnect", () => {
      console.log("disconnect");
    });
  });
};

module.exports = { initIO, getIO: () => IO, getSocket: () => socket };
