class CartModel {
  final String userId;
  final String productId;
  final DateTime created;
  final int cartQty;

  CartModel({
    required this.userId,
    required this.productId,
    required this.created,
    this.cartQty = 1, // Số lượng mặc định là 1
  });

  // Hàm chuyển CartModel thành Map để lưu trữ trong Firestore
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'product_id': productId,
      'created': created.toIso8601String(),
      'cart_qty': cartQty,
    };
  }

  // Hàm khởi tạo CartModel từ Firestore document snapshot
  factory CartModel.fromFirestore(Map<String, dynamic> data) {
    return CartModel(
      userId: data['user_id'],
      productId: data['product_id'],
      created: DateTime.parse(data['created']),
      cartQty: data['cart_qty'],
    );
  }
}
