const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const userSchema = new Schema(
  {
    name: {
      type: String,
      required: [true, "Your name is required"],
      unique: true,
      trim: true,
    },
    email: {
      type: String,
      required: [true, "Your email address is required"],
      unique: true,
      match: [/.+@.+\..+/, "Must match an email address!"],
    },
    password: {
      type: String,
      required: [true, "Your password is required"],
      minlength: 5,
    },
    role: {
      type: Number,
      required: [true, "Please select a role."],
    },
  },
  { timestamps: true }
);

const User = mongoose.model("User", userSchema);

module.exports = User;
