const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const orderSchema = new Schema({
  placedBy: {
    type: String,
    required: [true, "User ID is required for this field."],
  },
  orderItems: {
    type: [{ type: String }],
  },
  orderNumber: {
    type: String,
    required: [true, "Shuffled order number must be generated."],
  },
  orderStatus: {
    type: String,
    required: [
      true,
      "Please set order status ['received', 'processing', 'complete']",
    ],
  },
});

// final numbers = <int>[1, 2, 3, 4, 5];
// numbers.shuffle();
//print(numbers); // [1, 3, 4, 5, 2] OR some other random result.

const Order = mongoose.model("Order", orderSchema);

module.exports = Order;
