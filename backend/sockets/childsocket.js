const { ChildSocketMap, ParentSocketMap } = require("../database/socket_map");
const Child = require("../database/child_model");
const addToHistory = require("../utilities/sockets/child_sockets/addtohistory");
const updatetoparent = require("../utilities/sockets/child_sockets/updatetoparent");
const childSocket = (socket, payload, IO) => {
  console.log(payload);

  ChildSocketMap.findOne({ childID: payload.id })
    .then((child) => {
      if (child) {
        child.socketID = socket.id;
        child.save();
      } else {
        Child.findOne({ _id: payload.id }, "parent").then((_) => {
          if (_) {
            console.log(_.parent);
            const newChildMap = new ChildSocketMap({
              socketID: socket.id,
              childID: payload.id,
              parentID: _.parent,
            });
            payload["parentID"] = _.parent;
            newChildMap.save();
          }
        });
      }
    })
    .catch((err) => {
      console.log(err);
      console.error(err);
    });

  socket.on("disconnect", () => {
    ChildSocketMap.findOneAndDelete({ socketID: socket.id }).then((_) => {});
  });

  socket.on("location", (data) => {
    Child.findOne({ _id: payload.id }).then(async (ch) => {
      ch.lastLocation = data;
      ch.live = true;
      ch.safe = true;
      await addToHistory(socket, payload, data, ch);
      await updatetoparent(IO, payload.parentID, ch);
      await ch.save();
    });
  });
};

module.exports = childSocket;
