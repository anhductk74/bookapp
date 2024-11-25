import 'package:flutter/material.dart';
import 'package:bookapp/views/home/component/top_products.dart';
import '../../models/category.dart';
import 'component/banner_slider.dart';
import 'component/categories.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    getCategories();
    getProducts();
    getEverydayProducts();
  }

  getCategories() async {
    // categories = await CategoryProvider(context).getMainCategories();
    setState(() {});
  }

  getProducts() async {
    setState(() {});
  }

  getEverydayProducts() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Books Store",
          style: TextStyle(
            fontFamily: "Poppins-Light",
          ),
        ),
        backgroundColor: const Color(0xFF33bf2e),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const BannerSlider(),
            Categories(categories: categories),
            const SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: TopProducts(
                title: "Nexus Member Deals",
                // products: nexus_products,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
