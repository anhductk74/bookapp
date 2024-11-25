import 'package:flutter/material.dart';

class Products extends StatefulWidget {
  final String title;

  const Products({super.key, required this.title});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  // List<Product> products = [];

  @override
  void initState() {
    // log(widget.category_id.toString());
    getProducts();
  }

  getProducts() async {
    // products = await ProductProvider(context).getProductsByCategory(widget.category_id.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF33bf2e),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontFamily: "Poppins-Light",
          ),
        ),
      ),
      // body: GridView.count(
      //   crossAxisCount: 2,
      //   children: List<Widget>.generate(widget.products.length, (index) {
      //     return GridTile(
      //       child: ViewProduct(
      //         product: widget.products[index],
      //       ),
      //     );
      //   }),
      // ),
    );
  }
}
