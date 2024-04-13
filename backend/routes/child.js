const express = require("express");
const router = express.Router();
const jwt = require("jsonwebtoken");

const Child = require("../database/child_model");
const User = require("../database/user_model");

router.post("/new-child", async (req, res) => {
  console.log("called");
  const token = req.headers.authorization;
  console.log(token);
  try {
    try {
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      console.log(decoded);
      if (!decoded) {
        res.status(401).json({ message: "user not autunticated" });
        return;
      }

      const _id = decoded.id;
      const usr = await User.findById(_id);
      if (!usr) {
        res.status(404).json({ message: "user not found" });
        return;
      } else {
        const { name } = req.body;
        const newChild = Child({
          name,
          parent: _id,
        });
        const ch = await newChild.save();
        const parent = await User.findById(_id);
        parent.children.push(ch._id);
        await parent.save();
        res
          .status(200)
          .json({ message: "child added successfully", id: ch._id });
      }
    } catch (err) {
      console.error(err);
      res.status(401).json({ message: "user not autunticated" });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "internal server error" });
  }
});

module.exports = router;
