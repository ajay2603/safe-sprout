const mongoose = require("mongoose");

const childSchema = mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  lastLocation: {
    type: {
      latitude: Number,
      longitude: Number,
    },
    default: {
      latitude: 0,
      longitude: 0,
    },
  },
  tracking: {
    type: Boolean,
    default: false,
  },
  live: {
    type: Boolean,
    default: false,
  },
  safe: {
    type: Boolean,
    default: true,
  },
  history: [
    {
      date: {
        type: Date,
      },
      locations: [
        {
          latitude: Number,
          longitude: Number,
        },
      ],
    },
  ],
  parent: {
    type: String,
    required: true,
  },
});

const Child = mongoose.model("Child", childSchema);

module.exports = Child;
