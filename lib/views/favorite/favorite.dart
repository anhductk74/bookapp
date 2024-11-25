import 'dart:developer';
import 'package:bookapp/services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/product.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<Products> favoriteProducts = []; // Danh sách sản phẩm yêu thích
  UserService userService = UserService();
  String? userId;
  bool isLoading = true; // Biến để xác định trạng thái tải dữ liệu

  @override
  void initState() {
    super.initState();
    getUserId().then((_) {
      getFavoriteProducts(); // Lấy sản phẩm yêu thích khi khởi tạo trang
    });
  }

  // Lấy thông tin userId từ UserService
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

  // Lấy danh sách sản phẩm yêu thích của người dùng từ Firestore
  Future<void> getFavoriteProducts() async {
    if (userId == null) return; // Đảm bảo userId không null trước khi thực hiện
    try {
      setState(() {
        isLoading = true; // Bắt đầu tải dữ liệu
      });

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('user_id', isEqualTo: userId) // Tìm theo user_id
          .get();

      List<Products> products = [];
      for (var doc in snapshot.docs) {
        String productId = doc['product_id'];

        // Lấy chi tiết sản phẩm từ Firestore
        DocumentSnapshot productDoc = await FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .get();

        if (productDoc.exists) {
          Products product = Products.fromFirestore(
            productDoc.data() as Map<String, dynamic>,
            productDoc.id,
          );
          products.add(product);
        }
      }

      setState(() {
        favoriteProducts = products; // Cập nhật danh sách yêu thích
        isLoading = false; // Hoàn thành tải dữ liệu
      });
    } catch (e) {
      print("Error fetching favorite products: $e");
      setState(() {
        isLoading = false; // Nếu có lỗi, dừng trạng thái tải
      });
    }
  }

  // Xóa sản phẩm khỏi danh sách yêu thích
  Future<void> removeFavorite(String productId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('user_id', isEqualTo: userId)
          .where('product_id', isEqualTo: productId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.delete(); // Xóa sản phẩm
        log("Removed product with ID: $productId");

        // Cập nhật lại danh sách yêu thích sau khi xóa
        getFavoriteProducts();
      }
    } catch (e) {
      print("Error removing favorite: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(
            fontFamily: "Poppins-Light",
          ),
        ),
        backgroundColor: const Color(0xFF33bf2e),
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Hiển thị loading khi tải dữ liệu
          : favoriteProducts.isEmpty
              ? const Center(child: Text("No favorite products found."))
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: favoriteProducts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            favoriteProducts[index].image,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              favoriteProducts[index].name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "Rs.${favoriteProducts[index].price}",
                              style: const TextStyle(
                                color: Colors.green,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.red),
                            onPressed: () {
                              removeFavorite(favoriteProducts[index]
                                  .id); // Xóa sản phẩm khỏi yêu thích
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
