import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bookapp/models/category.dart';

class CategoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch categories from Firestore
  Future<List<Category>> fetchCategories() async {
    try {
      // Fetch data from Firestore's 'categories' collection
      QuerySnapshot snapshot = await _db.collection('categories').get();

      // Map Firestore documents to Category model
      List<Category> categories = snapshot.docs.map((doc) {
        return Category(
          id: doc.id,
          name: doc['name'],
          slug: doc['slug'],
          image: doc['image'],
          // You can add products if they are included in the Firestore documents
        );
      }).toList();

      return categories;
    } catch (e) {
      print("Error fetching categories: $e");
      return [];
    }
  }
}
