import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SliderScreen extends StatefulWidget {
  const SliderScreen({super.key});

  @override
  State<SliderScreen> createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  List imageList = [
    {"id": 1, "image_path": 'assets/slide.png'},
    {"id": 2, "image_path": 'assets/slide.png'},
    {"id": 3, "image_path": 'assets/slide.png'}
  ];
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () {},
          child: CarouselSlider(
            items: imageList
                .map(
                  (item) => Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Image.asset(
                      item['image_path'],
                      fit: BoxFit.fill,
                      width: double.infinity,
                    ),
                  ),
                )
                .toList(),
            options: CarouselOptions(
              scrollPhysics: const BouncingScrollPhysics(),
              autoPlay: true,
              aspectRatio: 2,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imageList.asMap().entries.map((entry) {
              return Container(
                width: currentIndex == entry.key ? 17 : 7,
                height: 7.0,
                margin: const EdgeInsets.symmetric(
                  horizontal: 3.0,
                ),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: currentIndex == entry.key ? Colors.red : Colors.teal),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
