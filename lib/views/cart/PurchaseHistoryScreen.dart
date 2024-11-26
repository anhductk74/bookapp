import 'dart:developer';

import 'package:bookapp/services/UserService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryState();
}

class _PurchaseHistoryState extends State<PurchaseHistoryScreen> {
  UserService userService = UserService();
  String? userId; // ID người dùng lấy từ dịch vụ UserService
  bool isLoading = true; // Trạng thái tải dữ liệu

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  // Hàm lấy userId từ dịch vụ hoặc Firebase Authentication
  Future<void> getUserId() async {
    Map<String, String> userData = await userService.getUserData();
    final newUserId = userData['uid'];

    setState(() {
      userId = newUserId;
      isLoading = false; // Cập nhật trạng thái tải
    });

    if (userId == null) {
      log("User ID is not available. Please log in.");
    }
  }

  // Hàm hiển thị dialog để nhập nhận xét
  void _showFeedbackDialog(
      BuildContext context, String orderId, String userId) {
    final TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Order Feedback'),
          content: TextField(
            controller: feedbackController,
            decoration: const InputDecoration(
              labelText: 'Enter your feedback',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Lưu nhận xét vào Firestore
                String feedback = feedbackController.text;
                if (feedback.isNotEmpty) {
                  await FirebaseFirestore.instance.collection('feedbacks').add({
                    'orderId': orderId,
                    'userId': userId,
                    'feedback': feedback,
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Purchase History"),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: userId) // Lọc theo userId
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No purchase history found.'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index].data() as Map<String, dynamic>;
              String orderId = orders[index].id;
              var items = List<Map<String, dynamic>>.from(order['items']);
              String address = order['address'] ?? 'No address';
              String name = order['name'] ?? 'No name';
              String phone = order['phone'] ?? 'No phone';
              double total = order['total']?.toDouble() ?? 0.0;
              var timestamp = (order['timestamp'] as Timestamp).toDate();
              String status = order['status'] ?? 'unconform';

              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order placed on: ${timestamp.toLocal()}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Name: $name'),
                      Text('Phone: $phone'),
                      Text('Address: $address'),
                      const SizedBox(height: 10),
                      for (var item in items)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Image.network(
                                item['productImage'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['productName']),
                                  Text('Quantity: ${item['cartQty']}'),
                                  Text('Price: ${item['productPrice']} VND'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      const Divider(),
                      Text('Total: $total VND',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Status: $status',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue)),
                      if (status == 'unconform')
                        ElevatedButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('orders')
                                .doc(orderId)
                                .delete();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Remove'),
                        ),
                      if (status == 'complete')
                        ElevatedButton(
                          onPressed: () {
                            _showFeedbackDialog(context, orderId, userId!);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Leave Feedback'),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
