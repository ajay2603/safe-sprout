const mongoose = require("mongoose");

const userSchema = mongoose.Schema({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  name: { type: String, required: true },
  children: [String],
  homeLocation: {
    latitude: Number,
    longitude: Number,
  },
});

const User = mongoose.model("User", userSchema);

module.exports = User;
