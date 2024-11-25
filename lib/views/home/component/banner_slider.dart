import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  List<String> imgList = [
    'https://cdn.9pay.vn/tin-tuc/blobid1691048380301-1691048393.jpg',
    'https://d19ri4mdy82u9u.cloudfront.net/images/652c921ff57c484e17bb256a/132NgwLbjBuIOvkYShEV.jpeg',
    'https://m.media-amazon.com/images/M/MV5BYWE2NDkyNjktNDA4MC00OTQ0LTg5ZDYtMjZlYmFhY2JjNGFkXkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.25,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.02,
          right: MediaQuery.of(context).size.width * 0.02,
        ),
        child: CarouselSlider(
          options: CarouselOptions(
            enlargeCenterPage: false,
            height: MediaQuery.of(context).size.height * 0.74,
            disableCenter: false,
            autoPlay: true,
            viewportFraction: 1,
            aspectRatio: 16 / 7,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
          ),
          items: imgList
              .map((item) => Container(
                    child: Center(
                        child: Image.network(
                      item,
                      fit: BoxFit.cover,
                      width: 1500,
                    )),
                  ))
              .toList(),
        ));
  }
}
