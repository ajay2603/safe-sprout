const express = require("express");
const router = express.Router();
const jwt = require("jsonwebtoken");
const User = require("../database/user_model");

router.get("/home-location", (req, res) => {
  const token = req.headers.authorization;
  try {
    try {
      var payload = jwt.verify(token, process.env.JWT_SECRET);
    } catch (err) {
      console.error(err);
      res.status(401).json({ message: "uset not authorized" });
      return;
    }
    const id = payload.id;
    User.findById(id)
      .then((usr) => {
        if (usr) {
          res.status(200).json({
            message: "loaction fetch success",
            homeLocation: usr.homeLocation,
          });
        } else {
          res.status(400).json({ message: "User not found" });
        }
      })
      .catch((err) => {
        res.status(500).json({ message: "Inter nal server error" });
      });
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: "Internal server error" });
  }
});

router.post("/set-home", (req, res) => {
  const token = req.headers.authorization;
  const { longitude, latitude } = req.body;
  try {
    try {
      var payload = jwt.verify(token, process.env.JWT_SECRET);
    } catch (err) {
      res.json({ message: "user not autunticated" });
      return;
    }
    const id = payload.id;
    User.findByIdAndUpdate(id, { homeLocation: { latitude, longitude } })
      .then((_) =>
        res.status(200).json({
          message: "location updated",
          homeLocation: _.homeLocation,
        })
      )
      .catch((err) => {
        console.error(err);
        res.status(500).json({ message: "unable to update home location" });
      });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  }
});

module.exports = router;
