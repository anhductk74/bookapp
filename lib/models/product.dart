class Products {
  final String id;
  final String name;
  final String image;
  final String price;
  final String description;
  final String qty;
  final String createAT;
  final String categoryId; // Add categoryId field

  Products({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.qty,
    required this.createAT,
    required this.categoryId, // Add categoryId to constructor
  });

  // Factory constructor to create a Product from Firestore document
  factory Products.fromFirestore(Map<String, dynamic> data, String id) {
    return Products(
      id: id,
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      price: data['price'] ?? '',
      description: data['description'] ?? '',
      qty: data['qty'] ?? '',
      createAT: data['createAT'],
      categoryId: data['category_id'] ?? '', // Fetch categoryId from Firestore
    );
  }
}
