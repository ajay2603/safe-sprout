const mongoose = require("mongoose");

const userSchema = mongoose.Schema({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  name: { type: String, required: true },
  children: [String],
  homeLocation: {
    type: {
      latitude: Number,
      longitude: Number,
    },
    default: null,
  },
});

const User = mongoose.model("User", userSchema);

module.exports = User;
