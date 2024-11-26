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
        leading: Padding(
          padding: const EdgeInsets.all(0.2), // Điều chỉnh khoảng cách
          child: Image.asset(
            'assets/logo.png', // Đường dẫn đến file logo
            fit: BoxFit.contain,
          ),
        ),
        title: const Center(
          child: Text(
            "Books Store",
            style: TextStyle(
              fontFamily: "Poppins-Light",
              fontWeight: FontWeight.bold, // Chữ đậm
              fontSize: 20,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications), // Icon chuông
            onPressed: () {
              // Thêm hành động khi bấm vào chuông
            },
          ),
          const SizedBox(width: 8), // Đảm bảo title không bị ép lệch
        ],
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const BannerSlider(),
            Categories(categories: categories),
            const SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: TopProducts(
                title: "Featured Products",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
