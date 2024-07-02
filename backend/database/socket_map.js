const mongoose = require("mongoose");

const childSocketMapSchema = mongoose.Schema({
  socketID: String,
  childID: String,
  parentID: String,
});

const ChildSocketMap = new mongoose.model("childSocket", childSocketMapSchema);

const parentSocketMapSchema = mongoose.Schema({
  socketIDS: [String],
  parentID: String,
});

const ParentSocketMap = mongoose.model("parentSocket", parentSocketMapSchema);

module.exports = { ChildSocketMap, ParentSocketMap };
