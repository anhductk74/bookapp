import 'dart:developer';

import 'package:bookapp/models/cart.dart';
import 'package:bookapp/models/product.dart';
import 'package:bookapp/services/CartService.dart';
import 'package:bookapp/services/UserService.dart';
import 'package:bookapp/views/product/view_individual_product.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsList extends StatefulWidget {
  final String categoryName;
  final String categoryId;

  const ProductsList({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  List<Products> products = [];
  bool isLoading = true; // Flag for loading state
  bool hasError = false; // Flag for error state

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      Query query = FirebaseFirestore.instance.collection('products');
      QuerySnapshot snapshot = await query.get();

      // Map Firestore documents to Products model
      List<Products> loadedProducts = snapshot.docs.map((doc) {
        return Products.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();

      setState(() {
        products = loadedProducts;
        isLoading = false;
        hasError = false; // Reset error state
      });
    } catch (e) {
      log('Error fetching products: $e');
      setState(() {
        isLoading = false;
        hasError = true; // Set error state to true
      });
    }
  }

  void retryFetch() {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    fetchProducts(); // Retry fetching the products
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
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while fetching
          : hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 50),
                      const SizedBox(height: 16),
                      const Text(
                        'Error fetching products. Please try again.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: retryFetch,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                              0xFF33bf2e), // Use backgroundColor instead of primary
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : products.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart_outlined,
                              size: 50, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No products available in this category',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        itemCount: products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.75, // Adjust item aspect ratio
                        ),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewIndividualProduct(
                                    product: product,
                                  ),
                                ),
                              );
                            },
                            child: ProductCard(product: product),
                          );
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

  // Lấy userId từ UserService
  Future<void> getUserId() async {
    Map<String, String> userData = await userService.getUserData();
    setState(() {
      userId = userData['uid'];
    });

    if (userId == null) {
      log("User ID is not available. Please log in.");
    }
  }

  // Thêm sản phẩm vào giỏ hàng
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
              onPressed: () => addToCart(context), // Gọi hàm khi nhấn nút
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
