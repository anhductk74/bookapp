import 'dart:developer';
import 'package:bookapp/models/product.dart';
import 'package:bookapp/views/category/component/product_card.dart';
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
  List<Products> filteredProducts = [];
  bool isLoading = true;
  bool hasError = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
    searchController.addListener(_filterProducts);
  }

  void fetchProducts() async {
    try {
      Query query = FirebaseFirestore.instance.collection('products');
      QuerySnapshot snapshot = await query.get();

      List<Products> loadedProducts = snapshot.docs.map((doc) {
        return Products.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();

      setState(() {
        products = loadedProducts;
        filteredProducts = loadedProducts;
        isLoading = false;
        hasError = false;
      });
    } catch (e) {
      log('Error fetching products: $e');
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  void _filterProducts() {
    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        filteredProducts = products;
      });
    } else {
      setState(() {
        filteredProducts = products.where((product) {
          return product.name.toLowerCase().contains(query);
        }).toList();
      });
    }
  }

  void retryFetch() {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    fetchProducts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search for books...',
                  prefixIcon: const Icon(Icons.search, color: Colors.green),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ),
            ),
          ),
        ),
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
              : filteredProducts.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart_outlined,
                              size: 50, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No products found for this category or search query.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        itemCount: filteredProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
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
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 150,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(product.image),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "\$${product.price.toString()}",
                                      style: TextStyle(
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
