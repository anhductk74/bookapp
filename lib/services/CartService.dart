import 'package:bookapp/models/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Hàm thêm sản phẩm vào giỏ hàng
  Future<void> addToCart(CartModel cartModel) async {
    try {
      // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
      QuerySnapshot snapshot = await _firestore
          .collection('cart')
          .where('user_id', isEqualTo: cartModel.userId)
          .where('product_id', isEqualTo: cartModel.productId)
          .get();

      if (snapshot.docs.isEmpty) {
        // Nếu sản phẩm chưa có, thêm sản phẩm vào giỏ hàng
        await _firestore.collection('cart').add(cartModel.toMap());
      } else {
        // Nếu sản phẩm đã có, cập nhật số lượng giỏ hàng
        DocumentSnapshot doc = snapshot.docs.first;
        await _firestore.collection('cart').doc(doc.id).update({
          'cart_qty': FieldValue.increment(1), // Tăng số lượng lên 1
        });
      }
    } catch (e) {
      print("Error adding product to cart: $e");
    }
  }
}
