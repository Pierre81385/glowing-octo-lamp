const router = require("express").Router();
const Product = require("../models/ProductModel");
const authenticateToken = require("../utils/jwtVerify");

//create new product
router.route("/create").post(authenticateToken, async (req, res) => {
  const product = req.body;
  const productExists = await Product.findOne({ name: product.name });

  if (productExists) {
    res
      .status(409)
      .json({ message: "CONFLICT, a product by this name already exists." });
  } else {
    const newProduct = new Product({
      name: product.name,
      description: product.description,
      price: product.price,
      count: product.count,
      category: product.category,
    });
    newProduct
      .save()
      .then(() => {
        res
          .status(200)
          .json({ message: "Product added!", product: newProduct });
      })
      .catch((error) => res.status(400).json({ message: error }));
  }
});

//read all
router.route("/").get(authenticateToken, (req, res) => {
  Product.find()
    .then((products) =>
      res.status(200).json({ message: "Found products!!", products: products })
    )
    .catch((err) => res.status(400).json({ message: err }));
});

//read one
router.route("/:id").get(authenticateToken, (req, res) => {
  Product.findById(req.params.id)
    .then((product) =>
      res.status(200).json({ message: "Found product!", product: product })
    )
    .catch((err) => res.status(400).json({ message: err }));
});

//update
router.route("/:id").put(authenticateToken, async (req, res) => {
  const product = req.body;

  const newProduct = new Product({
    name: product.name,
    description: product.description,
    price: product.price,
    count: product.count,
    category: product.category,
  });
  await Product.findByIdAndUpdate(
    { _id: req.params.id },
    {
      $set: {
        name: newProduct.name,
        description: newProduct.description,
        price: newProduct.price,
        count: newProduct.count,
        category: newProduct.category,
      },
    },
    {
      new: true,
    }
  )
    .then(() => {
      res.status(200).json({ message: "Product updated!" });
    })
    .catch((err) => {
      res.status(400).json({ message: err });
    });
});

//delete
router.route("/:id").delete(authenticateToken, (req, res) => {
  const { id } = req.params;
  Product.findByIdAndDelete(id)
    .then(() => {
      res.status(200).json({ message: "Product deleted!" });
    })
    .catch((err) => {
      res.status(400).json("Error: " + err);
    });
});

module.exports = router;
