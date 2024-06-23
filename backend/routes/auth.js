const express = require("express");
const router = express.Router();
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

const User = require("../database/user_model");
const Child = require("../database/child_model");

router.post("/register", async (req, res) => {
  const { email, name, password } = req.body;

  if (!email || !password || !name) {
    return res.status(400).json({ message: "Missing fields" });
  }

  try {
    const existingUser = await User.findOne({ email: email });
    if (existingUser) {
      res.status(409).json({ message: "Email already in use." });
      return;
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);
    const newUser = new User({
      email,
      name,
      password: hashedPassword,
    });

    await newUser.save();

    res.status(201).json({ message: "User created!" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  }
});

router.post("/login", (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    res.status(400).json({ message: "Missing fields" });
    return;
  }

  User.findOne({ email })
    .then(async (usr) => {
      if (usr) {
        if (await bcrypt.compare(password, usr.password)) {
          const token = jwt.sign(
            { email, id: usr._id, type: "parent" },
            process.env.JWT_SECRET
          );
          res
            .status(200)
            .json({ token, name: usr.name, message: "User authenticated" });
        } else {
          res.status(404).json({ message: "Incorrect Password" });
        }
      } else {
        res.status(404).json({ message: "User not found" });
      }
    })
    .catch((err) => {
      console.error(err);
      res.status(500).json("Database errro");
    });
});

router.post("/validate-token", (req, res) => {
  const token = req.headers.authorization;
  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET);
    if (payload) {
      if (payload.type == "parent") {
        User.findOne({ email: payload.email })
          .then((usr) => {
            if (usr) {
              res
                .status(200)
                .json({ message: "user authorized", type: payload.type });
            } else {
              res.status(401).json({ message: "user not authorized" });
            }
          })
          .catch((err) => {
            console.error(err);
            res.status(500).json({ message: "Internal Server error" });
          });
      } else if (payload.type == "child") {
        res
          .status(200)
          .json({ message: "user authorized", type: payload.type });
      } else res.status(401).json({ message: "user not authorized" });
    } else res.status(401).json({ message: "user not authorized" });
  } catch (err) {
    res.status(401).json({ message: "user not authorized" });
  }
});

router.post("/validate-pass", (req, res) => {
  const token = req.headers.authorization;
  const password = req.body.password;

  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET);
    if (payload) {
      User.findOne({ email: payload.email })
        .then(async (usr) => {
          if (usr) {
            if (await bcrypt.compare(password, usr.password))
              res.status(200).json({ message: "User authorized" });
            else res.status(401).json({ message: "Incorrect Password" });
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

router.post("/gen/token", (req, res) => {
  const token = req.headers.authorization;
  const pass = req.body.password;
  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET);
    if (payload) {
      Child.findOne({ _id: payload.id })
        .then((ch) => {
          if (ch) {
            User.findOne({ _id: ch.parent })
              .then((usr) => {
                if (usr) {
                  if (pass == usr.password) {
                    res.status(401).json({ message: "user not authorized" });
                    return;
                  }
                  const token = jwt.sign(
                    { email: usr.email, id: usr._id, type: "parent" },
                    process.env.JWT_SECRET
                  );
                  res
                    .status(200)
                    .json({ message: "token created success", token: token });
                } else res.status(401).json({ message: "user not authorized" });
              })
              .catch((err) => {
                console.error(err);
                res
                  .json(500)
                  .json({ message: "Error in fetching data try again" });
              });
          } else {
            res.status(404).json({ message: "child not found" });
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

module.exports = router;
