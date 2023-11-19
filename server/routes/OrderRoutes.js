const router = require("express").Router();
const Order = require("../models/OrderModel");

//create new product
router.route("/create").post(async (req, res) => {
  const order = req.body;

  const newOrder = new Order({
    placedBy: order.placedBy,
    orderItems: order.orderItems,
    orderNumber: order.orderNumber,
    orderStatus: order.orderStatus,
  });
  newOrder
    .save()
    .then(() => {
      res.status(200).json({ message: "Order sent!", order: newOrder });
    })
    .catch((error) => res.status(400).json({ message: error }));
});

//read all
router.route("/").get((req, res) => {
  Order.find()
    .then((orders) => res.status(200).json(orders))
    .catch((err) => res.status(400).json("Error: " + err));
});

//read one
router.route("/:id").get((req, res) => {
  Order.findById(req.params.id)
    .then((order) => res.status(200).json(order))
    .catch((err) => res.status(400).json("Error: " + err));
});

//update
router.route("/:id").put(async (req, res) => {
  const order = req.body;

  const newOrder = new Order({
    placedBy: order.placedBy,
    orderItems: order.orderItems,
    orderNumber: order.orderNumber,
    orderStatus: order.orderStatus,
  });
  await order
    .findByIdAndUpdate(
      { _id: newOrder.id },
      {
        $set: {
          placedBy: newOrder.placedBy,
          orderItems: newOrder.orderItems,
          orderNumber: newOrder.orderNumber,
          orderStatus: newOrder.orderStatus,
        },
      },
      {
        new: true,
      }
    )
    .then(() => {
      res.status(200).json("Success!");
    })
    .catch((err) => {
      res.status(400).json("Error: " + err);
    });
});

//delete
router.route("/:id").delete((req, res) => {
  const { id } = req.params;
  Order.findByIdAndDelete(id)
    .then(() => {
      res.status(200).json({ message: "Order deleted!" });
    })
    .catch((err) => {
      res.status(400).json("Error: " + err);
    });
});

module.exports = router;
