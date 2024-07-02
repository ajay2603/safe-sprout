const { ParentSocketMap } = require("../database/socket_map");

const parentSocket = (socket, paylode) => {
  ParentSocketMap.findOne({ parentID: paylode.id }).then((par) => {
    if (par) {
      par.socketIDS.push(socket.id);
      par.save();
    } else {
      const pare = new ParentSocketMap({
        parentID: paylode.id,
        socketIDS: [socket.id],
      });

      pare.save();
    }
  });

  socket.on("disconnect", () => {
    ParentSocketMap.findOne({ parentID: paylode.id }).then((par) => {
      if (par) {
        par.socketIDS = par.socketIDS.filter((sid) => sid != socket.id);
        if (par.socketIDS.length == 0) {
          ParentSocketMap.findOneAndDelete({ parentID: paylode.id });
        } else par.save();
      }
    });
  });

  console.log("parent socket");
  console.log(paylode);
};

module.exports = parentSocket;
