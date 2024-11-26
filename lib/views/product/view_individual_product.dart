import 'dart:developer';
import 'package:bookapp/models/cart.dart';
import 'package:bookapp/services/UserService.dart';
import 'package:bookapp/services/CartService.dart'; // Thêm import CartService
import 'package:flutter/material.dart';
import '../../models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewIndividualProduct extends StatefulWidget {
  final Products product;

  const ViewIndividualProduct({super.key, required this.product});

  @override
  State<ViewIndividualProduct> createState() => _ViewIndividualProductState();
}

class _ViewIndividualProductState extends State<ViewIndividualProduct> {
  List<Products> similarProducts = [];
  bool isFavorited = false;
  UserService userService = UserService();
  String? userId;
  CartService cartService = CartService(); // Khởi tạo CartService

  @override
  void initState() {
    super.initState();
    getUserId().then((_) {
      getSimilarProducts();
      checkIfFavorited();
    });
  }

  Future<void> getUserId() async {
    Map<String, String> userData = await userService.getUserData();
    userId = userData['uid'];
    setState(() {
      userId = userData['uid'];
    });

    if (userId == null) {
      log("User ID is not available. Please log in.");
    }
  }

  getSimilarProducts() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('category_id', isEqualTo: widget.product.categoryId)
          .limit(5)
          .get();

      List<Products> products = snapshot.docs.map((doc) {
        return Products.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();

      setState(() {
        similarProducts = products;
      });
    } catch (e) {
      log("Error fetching similar products: $e");
    }
  }

  Future<void> checkIfFavorited() async {
    if (userId == null) {
      log("User is not logged in. Cannot check if the product is favorited.");
      return;
    }

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('product_id', isEqualTo: widget.product.id)
          .where('user_id', isEqualTo: userId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          isFavorited = true;
        });
      }
    } catch (e) {
      log("Error checking favorite: $e");
    }
  }

  Future<void> toggleFavorite() async {
    if (userId == null) {
      log("User is not logged in. Cannot toggle favorite.");
      return;
    }

    if (isFavorited) {
      try {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('favorites')
            .where('product_id', isEqualTo: widget.product.id)
            .where('user_id', isEqualTo: userId)
            .get();

        for (var doc in snapshot.docs) {
          await FirebaseFirestore.instance
              .collection('favorites')
              .doc(doc.id)
              .delete();
        }

        setState(() {
          isFavorited = false;
        });
      } catch (e) {
        log("Error removing favorite: $e");
      }
    } else {
      try {
        await FirebaseFirestore.instance.collection('favorites').add({
          'product_id': widget.product.id,
          'user_id': userId,
          'createAt': DateTime.now().toIso8601String(),
        });

        setState(() {
          isFavorited = true;
        });
      } catch (e) {
        log("Error adding favorite: $e");
      }
    }
  }

  // Thêm sản phẩm vào giỏ hàng
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF33bf2e),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Product details
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05,
                    ),
                    child: Image.network(
                      widget.product.image,
                      width: MediaQuery.of(context).size.width * 0.60,
                      height: MediaQuery.of(context).size.height * 0.30,
                    ),
                  ),
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontFamily: 'Poppins-Bold',
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    "${widget.product.price} VNĐ",
                    style: const TextStyle(
                      fontFamily: 'Poppins-Light',
                      fontSize: 20,
                    ),
                  ),
                  // Product description
                  Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 15,
                      right: 15,
                    ),
                    child: Text(
                      widget.product.description,
                      style: const TextStyle(
                          fontFamily: 'Poppins-Light', fontSize: 14),
                    ),
                  ),
                  // Thêm chức năng tim yêu thích
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: IconButton(
                      icon: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: isFavorited ? Colors.red : Colors.black,
                        size: 30,
                      ),
                      onPressed: () {
                        toggleFavorite();
                      },
                    ),
                  ),
                  // Add to Cart Button
                  Container(
                    margin: const EdgeInsets.only(
                      top: 15,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        addToCart(context); // Gọi hàm addToCart với context
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF33bf2e), // Màu nền
                        foregroundColor: Colors.white, // Màu chữ
                      ),
                      child: const Text(
                        "Add To Cart",
                        style: TextStyle(fontFamily: 'Poppins-Light'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Similar Products section
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            // Similar Products UI ...
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Similar Products",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins-Light"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            child: const Text(
                              "View All",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF33bf2e),
                                  fontFamily: "Poppins-Light"),
                            ),
                            onTap: () {
                              // Navigate to category page or handle "View All"
                            },
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: const Icon(Icons.arrow_forward_ios_outlined,
                                size: 14, color: Colors.black45),
                          )
                        ],
                      )
                    ],
                  ),
                  // Display similar products
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...List.generate(similarProducts.length, (index) {
                          return InkWell(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 3),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Card(
                                      elevation: 0.8,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          similarProducts[index].qty == "0"
                                              ? const Text(
                                                  "Out of Stock",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                    fontFamily: "Poppins-Light",
                                                  ),
                                                )
                                              : const Text(''),
                                          Image.network(
                                            similarProducts[index].image,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.34,
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            similarProducts[index].name,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Poppins-Light",
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              "${similarProducts[index].price} VNĐ"),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (builder) => ViewIndividualProduct(
                                    product: similarProducts[index],
                                  ),
                                ),
                              );
                            },
                          );
                        })
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
