import 'package:flutter/material.dart';
import 'package:gym_app/models/trainer.dart';

class TrainerListScreen extends StatelessWidget {
  const TrainerListScreen({super.key, required this.trainerList});

  final List<Trainer> trainerList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: trainerList.length,
                  itemBuilder: (context, index) {
                    final trainer = trainerList[index];
                    return Card(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      color: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.4),
                              BlendMode.darken,
                            ),
                            child: Container(
                              height: MediaQuery.sizeOf(context).height / 2,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    trainer.imageUrl,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trainer.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                      ),
                                ),
                                Text(
                                  "${trainer.experienceYears} Years of Experience",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                      ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                    ),
                                    Text(
                                      "${trainer.rating} / 5.0",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary,
                                          ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
