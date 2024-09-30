import 'package:flutter/material.dart';

class ButtonTwo extends StatelessWidget {
  const ButtonTwo({super.key, required this.text, required this.imageUrl});
  final String text;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    // Increased the height for taller cards
    final double cardHeight = MediaQuery.of(context).size.height / 3; // taller card
    final double cardWidth = MediaQuery.of(context).size.width / 2.5;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          // Background image with increased height
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                opacity: 1,
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            width: cardWidth,
            height: cardHeight,
          ),

          // Semi-transparent overlay to darken the image
          Container(
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          // Position the text at the bottom of the card
          Positioned(
            bottom: 20, // Keeps text positioned near the bottom even with taller card
            left: 10,
            right: 10,
            child: Text(
              text,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.bold
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
