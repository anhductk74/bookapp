import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PurchaseHistoryScreen extends StatelessWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Purchase History"),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders') // Bộ sưu tập orders
            .where('userId',
                isEqualTo:
                    '3efe51ec-f3be-4dcc-81cc-ed774d28d210') // Lọc theo userId
            .snapshots(),
        builder: (context, snapshot) {
          // Kiểm tra trạng thái kết nối
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Xử lý lỗi khi lấy dữ liệu
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Kiểm tra dữ liệu trả về
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No purchase history found.'));
          }

          // Lấy dữ liệu đơn hàng từ Firebase
          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index].data() as Map<String, dynamic>;
              var items = List<Map<String, dynamic>>.from(order['items']);
              String address = order['address'] ?? 'No address';
              String name = order['name'] ?? 'No name';
              String phone = order['phone'] ?? 'No phone';
              double total = order['total']?.toDouble() ?? 0.0;
              var timestamp = (order['timestamp'] as Timestamp).toDate();
              String status =
                  order['status'] ?? 'conform'; // Lấy status từ dữ liệu

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
                      // Hiển thị các sản phẩm trong đơn hàng
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
                      // Hiển thị nút Remove nếu status là "unconform"
                      if (status == 'unconform')
                        ElevatedButton(
                          onPressed: () {
                            // Xử lý xóa đơn hàng
                            FirebaseFirestore.instance
                                .collection('orders')
                                .doc(orders[index].id)
                                .delete();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Remove'),
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

void main() {
  runApp(MaterialApp(
    home: PurchaseHistoryScreen(),
  ));
}
