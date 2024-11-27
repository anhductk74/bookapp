import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  final String userId;
  final List<Map<String, dynamic>> cartItems;

  const CheckoutScreen({
    super.key,
    required this.userId,
    required this.cartItems,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool isProcessing = false;

  num calculateTotal() {
    return widget.cartItems.fold<num>(0, (total, item) {
      return total + (item['productPrice'] * item['cartQty']);
    });
  }

  Future<void> processPayment() async {
    if (!_formKey.currentState!.validate()) {
      return; // Form chưa hợp lệ
    }

    setState(() {
      isProcessing = true;
    });

    try {
      // Create a new order document and get its orderId
      var orderRef = await FirebaseFirestore.instance.collection('orders').add({
        'userId': widget.userId,
        'name': _nameController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'total': calculateTotal(),
        'items': widget.cartItems,
        'status': 'unconform',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Add the generated orderId to the order
      await orderRef.update({
        'orderId': orderRef.id, // Set the generated orderId
      });

      // Xóa sản phẩm khỏi giỏ hàng
      for (var item in widget.cartItems) {
        await FirebaseFirestore.instance
            .collection('cart')
            .doc(item['cartId'])
            .delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order placed successfully!")),
      );

      // Quay lại màn hình trước hoặc về trang chính
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error placing order: $e")),
      );
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.green,
      ),
      body: isProcessing
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Recipient Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter recipient name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter phone number";
                        }
                        if (!RegExp(r'^\d{10,11}$').hasMatch(value)) {
                          return "Invalid phone number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: "Delivery Address",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter delivery address";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Total: \$${calculateTotal().toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: processPayment,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text("Confirm and Pay"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
