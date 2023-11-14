const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const userSchema = new Schema(
  {
    firstName: {
      type: String,
      required: [true, "Your first name is required"],
      unique: true,
      trim: true,
    },
    lastName: {
      type: String,
      required: [true, "Your last name is required"],
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
      type: String,
      required: [true, "Please select a role."],
    },
  },
  { timestamps: true }
);

const User = mongoose.model("User", userSchema);

module.exports = User;
