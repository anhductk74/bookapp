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
    'https://theme.hstatic.net/1000237375/1000756917/14/slider_item_1_image.jpg?v=1593',
    'https://theme.hstatic.net/1000237375/1000756917/14/slider_item_3_image.jpg?v=1593',
    'https://theme.hstatic.net/1000237375/1000756917/14/slider_item_4_image.jpg?v=1593',
    'https://theme.hstatic.net/1000237375/1000756917/14/slider_item_5_image.jpg?v=1593'
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
