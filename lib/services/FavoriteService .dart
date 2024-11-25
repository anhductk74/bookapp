import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bookapp/models/favorite.dart';

class FavoriteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Thêm một sản phẩm vào danh sách yêu thích
  Future<void> addFavorite(String productId, String userId) async {
    try {
      // Tạo đối tượng Favorite mới
      var newFavorite = Favorite(
        id: '', // Firestore sẽ tự động tạo ID cho document này
        productId: productId,
        userId: userId,
        createAt: DateTime.now().toIso8601String(), // Lưu thời gian hiện tại
      );

      // Thêm Favorite vào Firestore collection 'favorites'
      await _db.collection('favorites').add(newFavorite.toMap());

      print('Favorite added successfully');
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }

  // Lấy tất cả danh sách yêu thích của một người dùng từ Firestore
  Future<List<Favorite>> fetchFavoritesByUser(String userId) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('favorites')
          .where('user_id', isEqualTo: userId) // Lọc theo userId
          .get();

      // Chuyển đổi dữ liệu Firestore thành danh sách Favorite
      List<Favorite> favorites = snapshot.docs.map((doc) {
        return Favorite.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return favorites;
    } catch (e) {
      print('Error fetching favorites: $e');
      return [];
    }
  }

  // Xóa sản phẩm khỏi danh sách yêu thích
  Future<void> removeFavorite(String favoriteId) async {
    try {
      await _db.collection('favorites').doc(favoriteId).delete();
      print('Favorite removed successfully');
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }
}
