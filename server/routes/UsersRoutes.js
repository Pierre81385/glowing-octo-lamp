const router = require("express").Router();
const User = require("../models/UsersModel");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const authenticateToken = require("../utils/jwtVerify");
const { response } = require("express");

//create new user
router.route("/create").post(async (req, res) => {
  const user = req.body;
  const nameTaken = await User.findOne({ name: user.name });
  const emailTaken = await User.findOne({ email: user.email });

  if (nameTaken || emailTaken) {
    res
      .status(409)
      .json({ message: "CONFLICT, name or email address already in use." });
  } else {
    user.password = await bcrypt.hash(req.body.password, 10);
    const newUser = new User({
      name: user.name,
      email: user.email,
      password: user.password,
      role: user.role,
    });
    newUser
      .save()
      .then(() => {
        res.status(200).json({ message: "User added!", user: newUser });
      })
      .catch((error) => res.status(400).json({ message: error }));
  }
});

//login user
router.route("/login").post(async (req, res) => {
  const user = req.body;
  await User.findOne({ email: user.email }).then((u) => {
    if (!u) {
      return res.status(404).json({ message: "User not found" });
    }
    bcrypt.compare(user.password, u.password).then((match) => {
      if (match) {
        const payload = {
          id: u._id,
          name: u.email,
        };
        jwt.sign(
          payload,
          process.env.TOKEN_SECRET,
          { expiresIn: 86400 },
          (error, token) => {
            if (error) {
              return res.status(401).json({ message: error });
            } else {
              return res.status(200).json({
                message: "Login Success!",
                user: u,
                jwt: "Bearer " + token,
              });
            }
          }
        );
      } else {
        return res.status(409).json({
          message: "name or password is incorrect.",
        });
      }
    });
  });
});

//read all
router.route("/").get(authenticateToken, (req, res) => {
  User.find()
    .then((users) => res.status(200).json(users))
    .catch((err) => res.status(400).json("Error: " + err));
});

//read one
router.route("/:id").get(authenticateToken, (req, res) => {
  User.findById(req.params.id)
    .then((user) => res.status(200).json(user))
    .catch((err) => res.status(400).json("Error: " + err));
});

//update
router.route("/:name").put(authenticateToken, async (req, res) => {
  console.log(req);
  await User.findOneAndUpdate(
    { name: req.params.name },
    {
      $set: {
        name: req.body.name,
        email: req.body.email,
        password: req.body.password,
        role: req.body.role,
      },
    },
    {
      new: true,
    }
  )
    .then((data) => {
      res.status(200).json({ message: "Success!" });
    })
    .catch((err) => {
      res.status(400).json("Error: " + err);
    });
});

//delete
router.route("/:id").delete(authenticateToken, (req, res) => {
  const { id } = req.params;
  User.findByIdAndDelete(id)
    .then(() => {
      res.status(200).json("User deleted!");
    })
    .catch((err) => {
      res.status(400).json("Error: " + err);
    });
});

module.exports = router;
