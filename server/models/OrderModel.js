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
    type: Number,
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

const orderSchema = new Schema({
  placedBy: {
    type: String,
    required: [true, "User ID is required for this field."],
  },
  orderItems: [
    {
      name: {
        type: String,
        required: [true, "Product name is required."],
        trim: true,
      },
      description: {
        type: String,
        required: [true, "Product description is required."],
      },
      price: {
        type: Number,
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
    },
  ],
  orderNumber: {
    type: String,
    required: [true, "Shuffled order number must be generated."],
  },
  orderStatus: {
    type: String,
    required: [
      true,
      "Please set order status ['sent', 'received', 'processing', 'complete']",
    ],
  },
});

// final numbers = <int>[1, 2, 3, 4, 5];
// numbers.shuffle();
//print(numbers); // [1, 3, 4, 5, 2] OR some other random result.

const Order = mongoose.model("Order", orderSchema);

module.exports = Order;
