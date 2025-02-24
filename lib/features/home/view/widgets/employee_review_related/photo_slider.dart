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
  late CarouselSliderController _controller;

  @override
  void initState() {
    _controller = CarouselSliderController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Card(
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(6),
          //   color: Theme.of(context).colorScheme.surface,
          // ),
          // width: 200,
          child: widget.photoUrls.isEmpty
              ? const Center(
                  child: Icon(Icons.no_photography),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CarouselSlider(
                    carouselController: _controller,
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
                        .map((item) => Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              child: Center(
                                  child: Image.network(
                                item,
                                fit: BoxFit.cover,
                                height: widget.height,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child; // Когда изображение загружено, оно отображается.
                                  }
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer
                                            .withOpacity(0.5),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(0.5))),
                                    height: MediaQuery.of(context).size.height,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null, // Прогресс загрузки, если известен размер.
                                      ),
                                    ),
                                  );
                                },
                              )),
                            ))
                        .toList(),
                  ),
                ),
        ),
        Positioned(
          bottom: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.photoUrls.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () {
                  _controller.animateToPage(entry.key);
                },
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
