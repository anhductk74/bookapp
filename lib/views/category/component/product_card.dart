// lib/widgets/product_card.dart

import 'package:flutter/material.dart';
import 'package:bookapp/models/product.dart';
import 'package:bookapp/services/CartService.dart';
import 'package:bookapp/models/cart.dart';
import 'package:bookapp/services/UserService.dart';
import 'dart:developer';

class ProductCard extends StatefulWidget {
  final Products product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  UserService userService = UserService();
  String? userId;
  CartService cartService = CartService();

  @override
  void initState() {
    super.initState();
    getUserId(); // Lấy ID người dùng khi widget được tạo
  }

  Future<void> getUserId() async {
    Map<String, String> userData = await userService.getUserData();
    setState(() {
      userId = userData['uid'];
    });

    if (userId == null) {
      log("User ID is not available. Please log in.");
    }
  }

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
      cartQty: 1, // Số lượng mặc định là 1
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
