import 'package:bookapp/services/CategoryService.dart';
import 'package:flutter/material.dart';
import 'package:bookapp/models/category.dart';
import '../../category/product_categories.dart';

class Categories extends StatefulWidget {
  const Categories({super.key, required List<Category> categories});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  late Future<List<Category>> categories;

  @override
  void initState() {
    super.initState();
    categories = CategoryService().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: categories,
      builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No categories available'));
        }

        List<Category> categoriesList = snapshot.data!;

        return Column(
          children: [
            // Header row
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "All Categories",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins-Light",
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => const ProductCategories(
                            categoryId:
                                '', // View All without a specific category
                            categoryName: 'All Categories',
                          ),
                        ),
                      );
                    },
                    child: const Row(
                      children: [
                        Text(
                          "View All",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF33bf2e),
                            fontFamily: "Poppins-Light",
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 14,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Categories list
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.3,
              child: ListView.builder(
                itemCount: categoriesList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final category = categoriesList[index];
                  return InkWell(
                    onTap: () {
                      // When a category is tapped, navigate to the ProductCategories page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductCategories(
                            categoryId: category.id, // Pass the category id
                            categoryName:
                                category.name, // Pass the category name
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 100,
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.02,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Category image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              category.image,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image_not_supported,
                                  size: 60,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          ),

                          // Category name
                          const SizedBox(height: 8),
                          Text(
                            category.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Poppins-Light",
                            ),
                            textAlign: TextAlign.center,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis, // Handle long text
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
