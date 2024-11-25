class Favorite {
  final String id;
  final String productId;
  final String userId;
  final String createAt;

  Favorite({
    required this.id,
    required this.productId,
    required this.userId,
    required this.createAt,
  });

  // Factory constructor to create a Favorite from Firestore document
  factory Favorite.fromFirestore(Map<String, dynamic> data, String id) {
    return Favorite(
      id: id,
      productId: data['product_id'] ?? '',
      userId: data['user_id'] ?? '',
      createAt: data['createAt'] ?? '',
    );
  }

  // Method to convert Favorite to Firestore data
  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'user_id': userId,
      'createAt': createAt,
    };
  }
}
