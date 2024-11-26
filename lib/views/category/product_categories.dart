import 'dart:developer';

import 'package:bookapp/models/cart.dart';
import 'package:bookapp/models/product.dart';
import 'package:bookapp/services/CartService.dart';
import 'package:bookapp/services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCategories extends StatefulWidget {
  final String categoryName;
  final String categoryId;

  const ProductCategories({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  State<ProductCategories> createState() => _ProductCategoriesState();
}

class _ProductCategoriesState extends State<ProductCategories> {
  List<Products> products = [];
  bool isLoading = true; // Flag for loading state

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      // Fetch products where category_id matches the selected category
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('category_id', isEqualTo: widget.categoryId)
          .get();
      // Map Firestore documents to Products model
      List<Products> loadedProducts = snapshot.docs.map((doc) {
        return Products.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();

      // Update state with fetched products and loading flag
      setState(() {
        products = loadedProducts;
        isLoading = false; // Set loading flag to false
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        isLoading = false; // Stop loading in case of error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(fontFamily: "Poppins-Light"),
        ),
        backgroundColor: const Color(0xFF33bf2e),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? const Center(
                  child: Text('No products available in this category'))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                          product: product); // Passing product to card
                    },
                  ),
                ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Products product;

  const ProductCard({super.key, required this.product});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  UserService userService = UserService();
  String? userId;
  CartService cartService = CartService();

  @override
  void initState() {
    super.initState();
    getUserId(); // Fetch user ID when the widget is initialized
  }

  // Get the user ID from UserService
  Future<void> getUserId() async {
    Map<String, String> userData = await userService.getUserData();
    setState(() {
      userId = userData['uid'];
    });

    if (userId == null) {
      log("User ID is not available. Please log in.");
    }
  }

  // Add product to cart
  Future<void> addToCart(BuildContext context) async {
    if (userId == null) {
      log("User is not logged in. Cannot add to cart.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please log in to add items to your cart."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    CartModel cartModel = CartModel(
      userId: userId!,
      productId: widget.product.id,
      created: DateTime.now(),
      cartQty: 1, // Default quantity
    );

    try {
      await cartService.addToCart(cartModel);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${widget.product.name} added to cart successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      log("Error adding to cart: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to add item to cart. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                widget.product.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 50),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              widget.product.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '\$${widget.product.price}',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Qty: ${widget.product.qty}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: () => addToCart(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF33bf2e),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Add to Cart'),
            ),
          ),
        ],
      ),
    );
  }
}
