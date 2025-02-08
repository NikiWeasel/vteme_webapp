import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoSlider extends StatefulWidget {
  const PhotoSlider({super.key, required this.photoUrls, required this.height});

  final List<String> photoUrls;
  final double height;

  @override
  State<PhotoSlider> createState() => _PhotoSliderState();
}

class _PhotoSliderState extends State<PhotoSlider> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Theme.of(context).colorScheme.surface,
          ),
          // width: 200,
          child: CarouselSlider(
            options: CarouselOptions(
                height: widget.height,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                autoPlay: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
            items: widget.photoUrls
                .map((item) => ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Center(
                            child: Image.network(
                          item,
                          fit: BoxFit.cover,
                          height: widget.height,
                        )),
                      ),
                    ))
                .toList(),
          ),
        ),
        Positioned(
          bottom: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.photoUrls.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.light
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
