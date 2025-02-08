import 'package:flutter/cupertino.dart';

class SquareAvatar extends StatelessWidget {
  const SquareAvatar(
      {super.key, this.child, this.foregroundImage, required this.size});

  final double size;
  final Widget? child;
  final ImageProvider? foregroundImage;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: size,
      height: size,
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        image: DecorationImage(
          image: foregroundImage!,
          // onError: onForegroundImageError,
          fit: BoxFit.cover,
        ),
        shape: BoxShape.rectangle,
      ),
      duration: const Duration(milliseconds: 200),
      child: child,
    );
  }
}
