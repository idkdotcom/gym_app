import 'package:flutter/material.dart';

class TrainerCard extends StatelessWidget {
  const TrainerCard({super.key, required this.name, required this.imageUrl});
  final String name;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                opacity: 1,
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            width: MediaQuery.of(context).size.width / 2.5,
            height: MediaQuery.of(context).size.height / 4,
          ),
          
          Container(
            width: MediaQuery.of(context).size.width / 2.5,
            height: MediaQuery.of(context).size.height / 4,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 0,
            child: Text(
              name,
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
