import 'package:bookapp/models/product.dart';
import 'package:bookapp/views/category/component/product_card.dart';
import 'package:bookapp/views/product/view_individual_product.dart';
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
                      return GestureDetector(
                        onTap: () {
                          // Khi nhấn vào sản phẩm, điều hướng đến trang chi tiết
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
                            product: product), // Using ProductCard widget
                      );
                    },
                  ),
                ),
    );
  }
}
