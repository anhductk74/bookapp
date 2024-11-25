import 'package:flutter/material.dart';
import 'package:bookapp/models/product.dart';

class ViewProduct extends StatefulWidget {
  final Products product;

  const ViewProduct({super.key, required this.product});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Color(0xFF33bf2e),
      //   title: Text(
      //     "${widget.product.category}",
      //     style: const TextStyle(
      //       fontFamily: 'Poppins-Light',
      //     ),
      //   ),
      // ),
      body: Container(
        child: Column(
          children: [
            Image.network(widget.product.image),
            Text(widget.product.name),
            Text("Rs.${widget.product.price}")
          ],
        ),
      ),
    );
  }
}
