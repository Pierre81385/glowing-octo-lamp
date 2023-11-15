const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const productSchema = new Schema({
  name: {
    type: String,
    required: [true, "Product name is required."],
    unique: true,
    trim: true,
  },
  description: {
    type: String,
    required: [true, "Product description is required."],
  },
  price: {
    type: String,
    required: [true, "Product price is required."],
  },
  count: {
    type: Number,
    required: [true, "Product count is required."],
  },
  category: {
    type: String,
    required: [true, "Please specify product category."],
  },
});

const Product = mongoose.model("Product", productSchema);

module.exports = Product;
