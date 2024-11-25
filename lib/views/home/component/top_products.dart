import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bookapp/views/product/view_individual_product.dart';
import '../../../models/product.dart';

class TopProducts extends StatefulWidget {
  final String title;

  const TopProducts({super.key, required this.title});

  @override
  State<TopProducts> createState() => _TopProductsState();
}

class _TopProductsState extends State<TopProducts> {
  List<Products> _topProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTopProducts();
  }

  // Fetch top 10 latest products from Firestore
  Future<void> _fetchTopProducts() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .orderBy('createAT', descending: true) // Sort by creation date
          .limit(10) // Get the latest 10 products
          .get();

      List<Products> products = snapshot.docs.map((doc) {
        return Products.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();

      setState(() {
        _topProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      log("Error fetching top products: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.02),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.10,
          ),
          // Title and View All button
          Container(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.04,
                left: MediaQuery.of(context).size.width * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins-Light",
                  ),
                ),
                InkWell(
                  child: const Row(
                    children: [
                      Text(
                        "View All",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF33bf2e),
                          fontFamily: "Poppins-Light",
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_outlined,
                          size: 14, color: Colors.black45),
                    ],
                  ),
                  onTap: () {
                    // Handle "View All" action if needed
                    // Navigate to a full list of products or details screen
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.02,
          ),
          // Displaying products in horizontal scroll
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _topProducts.isEmpty
                  ? const Center(child: Text("No products available"))
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _topProducts.map((product) {
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
                            child: Container(
                              margin: const EdgeInsets.only(right: 15),
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: product.image.isNotEmpty
                                          ? Image.network(
                                              product.image,
                                              width: double.infinity,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.34,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              color: Colors.grey[300],
                                              width: double.infinity,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.34,
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                size: 50,
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  // Display price as string (no conversion)
                                  Text(
                                    "Price.${product.price}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
        ],
      ),
    );
  }
}
