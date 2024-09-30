import 'package:flutter/material.dart';

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({super.key, required this.ImagePath});
  final String ImagePath;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ImagePath, fit: BoxFit.cover,
    );
  }
}