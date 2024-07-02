const { ChildSocketMap, ParentSocketMap } = require("../database/socket_map");

const clearSocketData = () => {
  return new Promise(async (resolve, reject) => {
    try {
      await ChildSocketMap.deleteMany();
      await ParentSocketMap.deleteMany();
      resolve(true);
    } catch (err) {
      reject(err);
    }
  });
};

module.exports = clearSocketData;
