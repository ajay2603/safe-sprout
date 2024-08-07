const express = require("express");
const router = express.Router();
const jwt = require("jsonwebtoken");

const Child = require("../database/child_model");
const User = require("../database/user_model");

const { getIO } = require("../sockets/socket");

const { ParentSocketMap } = require("../database/socket_map");

const { getCurrentDayLoc } = require("../utilities/datesfetch");

router.get("/all", async (req, res) => {
  const token = req.headers.authorization;
  try {
    try {
      var decoded = jwt.verify(token, process.env.JWT_SECRET);
    } catch (err) {
      console.error(err);
      res.status(401).json({ message: "user not autunticated" });
      return;
    }

    const _id = decoded.id;
    const usr = await User.findOne({ _id });
    if (!usr) {
      res.status(404).json({ message: "user not found" });
      return;
    }

    const childrenList = await Child.find({ _id: { $in: usr.children } })
      .select("_id name live tracking safe lastLocation")
      .lean();

    res
      .status(200)
      .json({ message: "childern fetched success", children: childrenList });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "internal server error" });
  }
});

router.post("/new-child", async (req, res) => {
  const token = req.headers.authorization;
  try {
    try {
      var decoded = jwt.verify(token, process.env.JWT_SECRET);
    } catch (err) {
      console.error(err);
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

      res.status(200).json({
        message: "child added successfully",
        child: {
          _id: ch._id,
          name: ch.name,
          tracking: ch.tracking,
          safe: ch.safe,
          live: ch.live,
          lastLocation: ch.lastLocation,
        },
      });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "internal server error" });
  }
});

router.post("/gen/child-id", (req, res) => {
  const token = req.headers.authorization;
  const childID = req.body.id;
  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET);
    if (payload) {
      User.findOne({ email: payload.email })
        .then(async (usr) => {
          if (usr) {
            if (usr.children.includes(childID)) {
              const token = jwt.sign(
                { id: childID, type: "child" },
                process.env.JWT_SECRET
              );

              const chh = await Child.findOne({ _id: childID });
              if (chh) {
                if (chh.tracking == true) {
                  res.status(409).json({
                    message: "This child is being tracked by other device",
                  });
                  return;
                }
                chh.tracking = true;
                chh.save().then(() => {
                  const IO = getIO();
                  if (IO) {
                    ParentSocketMap.findOne({ parentID: usr._id }).then(
                      (par) => {
                        if (par) {
                          par.socketIDS.forEach((sid) => {
                            IO.to(sid).emit("upDateTracking", {
                              tracking: true,
                              id: childID,
                            });
                          });
                        }
                      }
                    );
                  }
                });
              }

              Child.findOne({ _id: childID }).then((ch) => {
                if (ch.history.length != 0) {
                  ch.history[ch.history.length - 1].continue = true;
                  let list = ch.history[ch.history.length - 1].locations;
                  if (list.length == 0) {
                    ch.history[ch.history.length - 1].locations.push([]);
                  } else {
                    let lastList = list[list.length - 1];
                    if (lastList.length != 0) {
                      ch.history[ch.history.length - 1].locations.push([]);
                    }
                  }
                  ch.save();
                }
              });

              res
                .status(200)
                .json({ message: "token created success", token: token });
            } else res.status(404).json({ message: "child not found" });
          } else {
            res.status(401).json({ message: "user not authorized" });
          }
        })
        .catch((err) => {
          console.error(err);
          res.status(500).json({ message: "Internal Server error" });
        });
    } else res.status(401).json({ message: "user not authorized" });
  } catch (err) {
    res.status(401).json({ message: "user not authorized" });
  }
});

router.get("/info", async (req, res) => {
  const token = req.headers.authorization;
  const { id } = req.query;
  try {
    try {
      var payload = jwt.verify(token, process.env.JWT_SECRET);
    } catch (err) {
      console.error(err);
      res.status(401).json({ message: "user not authorized" });
      return;
    }
    const _id = payload.id;
    const usr = await User.findById(_id);
    if (usr.children.includes(id)) {
      const { name, lastLocation, tracking, live, safe } = await Child.findById(
        id
      );
      res.status(200).json({
        info: { name, lastLocation, tracking, live, safe },
        message: "child details fetched successfully",
      });
    } else {
      res.status(401).json({ message: "user not authorized" });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  }
});

module.exports = router;
