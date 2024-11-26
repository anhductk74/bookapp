import 'dart:developer';
import 'package:bookapp/services/UserService.dart';
import 'package:bookapp/views/cart/PurchaseHistoryScreen.dart';
import 'package:bookapp/views/cart/checkout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  UserService userService = UserService();
  String? userId;
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserId(); // Lấy userId và tự động tải dữ liệu giỏ hàng
  }

  Future<void> getUserId() async {
    Map<String, String> userData = await userService.getUserData();
    final newUserId = userData['uid'];

    setState(() {
      userId = newUserId;
    });

    if (userId != null) {
      await fetchCartItems();
    } else {
      log("User ID is not available. Please log in.");
    }
  }

  Future<void> fetchCartItems() async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('cart')
          .where('user_id', isEqualTo: userId)
          .get();

      List<Map<String, dynamic>> items = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> cartData = doc.data() as Map<String, dynamic>;

        // Lấy chi tiết sản phẩm từ `products` collection
        DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .doc(cartData['product_id'])
            .get();

        if (productSnapshot.exists) {
          Map<String, dynamic> productData =
              productSnapshot.data() as Map<String, dynamic>;

          items.add({
            'cartId': doc.id,
            'productName': productData['name'],
            'productPrice': num.tryParse(productData['price'].toString()) ?? 0,
            'productImage': productData['image'],
            'cartQty': cartData['cart_qty'],
          });
        }
      }

      setState(() {
        cartItems = items;
      });
    } catch (e) {
      debugPrint("Error fetching cart items: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateCartItemQuantity(String cartId, int quantity) async {
    if (quantity < 1) {
      // Xóa sản phẩm nếu số lượng < 1
      await FirebaseFirestore.instance.collection('cart').doc(cartId).delete();
      setState(() {
        cartItems.removeWhere((item) => item['cartId'] == cartId);
      });
    } else {
      // Cập nhật số lượng
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(cartId)
          .update({'cart_qty': quantity});

      // Chỉ cập nhật số lượng trong bộ nhớ
      setState(() {
        cartItems = cartItems.map((item) {
          if (item['cartId'] == cartId) {
            item['cartQty'] = quantity;
          }
          return item;
        }).toList();
      });
    }
  }

  num calculateTotal() {
    return cartItems.fold<num>(0, (total, item) {
      return total + (item['productPrice'] * item['cartQty']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cart",
          style: TextStyle(fontFamily: "Poppins-Light"),
        ),
        centerTitle: true, // Centers the title

        backgroundColor: Colors.green,
        actions: [
          // Thêm một nút "Lịch sử mua hàng" ở phía bên phải AppBar
          IconButton(
            icon: const Icon(Icons.history), // Biểu tượng lịch sử
            onPressed: () {
              // Điều hướng tới màn hình lịch sử mua hàng khi nhấn vào nút
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PurchaseHistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        child: ListTile(
                          leading: Image.network(
                            item['productImage'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(item['productName']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Price: ${item['productPrice']} x ${item['cartQty']}"),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      updateCartItemQuantity(
                                          item['cartId'], item['cartQty'] - 1);
                                    },
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Text("${item['cartQty']}"),
                                  IconButton(
                                    onPressed: () {
                                      updateCartItemQuantity(
                                          item['cartId'], item['cartQty'] + 1);
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Total: ${calculateTotal().toStringAsFixed(2)} VNĐ",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutScreen(
                                userId: userId!,
                                cartItems: cartItems,
                              ),
                            ),
                          );

                          // Nếu thanh toán thành công, làm mới giỏ hàng
                          if (result == true) {
                            fetchCartItems();
                          }
                        },
                        child: const Text("Proceed to Checkout"),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
