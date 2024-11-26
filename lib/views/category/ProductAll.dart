import 'dart:developer';
import 'package:bookapp/models/product.dart';
import 'package:bookapp/views/category/component/product_card.dart';
import 'package:bookapp/views/category/product_categories.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bookapp/views/product/view_individual_product.dart';

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
          ? const Center(child: CircularProgressIndicator())
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
                          backgroundColor: const Color(0xFF33bf2e),
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
                              // Navigate to ViewIndividualProduct when a product is tapped
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewIndividualProduct(
                                    product: product,
                                  ),
                                ),
                              );
                            },
                            child: ProductCard(
                                product: product), // Use ProductCard widget
                          );
                        },
                      ),
                    ),
    );
  }
}
