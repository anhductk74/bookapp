// import 'package:flutter/material.dart';
// import 'package:bookapp/models/category.dart';
// import 'package:bookapp/views/category/category_product.dart';

// class ViewCategory extends StatefulWidget {
//   final Category category;

//   const ViewCategory({super.key, required this.category});

//   @override
//   State<ViewCategory> createState() => _ViewCategoryState();
// }

// class _ViewCategoryState extends State<ViewCategory> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width * 0.30,
//       height: MediaQuery.of(context).size.width * 0.29,
//       child: InkWell(
//         highlightColor: Colors.transparent,
//         splashColor: Colors.transparent,
//         onTap: () => {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (builder) => CategoryProduct(
//                 category: widget.category,
//               ),
//             ),
//           )
//         },
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Container(
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 color: const Color(0xFF33bf2e),
//               ),
//               margin: const EdgeInsets.only(left: 5),
//               padding: const EdgeInsets.all(12),
//               child: Text(
//                 widget.category.name,
//                 style: const TextStyle(color: Colors.white, fontSize: 16),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
