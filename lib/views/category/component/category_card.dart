import 'package:flutter/material.dart';
import 'package:bookapp/models/category.dart';

import '../category_product.dart';

class CategoryCard extends StatefulWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => CategoryProduct(
                category: widget.category,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    widget.category.image,
                    width: MediaQuery.of(context).size.width * 0.47,
                    height: MediaQuery.of(context).size.height * 0.18,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      widget.category.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins-Light",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
