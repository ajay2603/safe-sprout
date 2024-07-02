const { ParentSocketMap } = require("../../../database/socket_map");

const updatetoparent = async (IO, parentID, ch) => {
  ParentSocketMap.findOne({ parentID }).then((parent) => {

    if (parent) {
      parent.socketIDS.forEach((sid) => {
        console.log("emit");
        IO.to(sid).emit("childInfo", {
          _id: ch._id,
          lastLocation: ch.lastLocation,
          tracking: ch.tracking,
          live: ch.live,
          safe: ch.safe,
        });
      });
    }
  });
};

module.exports = updatetoparent;
