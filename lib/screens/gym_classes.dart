import 'package:flutter/material.dart';
import 'package:gym_app/models/class.dart';

class GymClassesScreen extends StatelessWidget {
  const GymClassesScreen({super.key, required this.classList});

  final List<Class> classList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: classList.length,
                  itemBuilder: (context, index) {
                    final currentClass = classList[index];
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
                                    currentClass.imageUrl,
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
                                  currentClass.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                      ),
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                  currentClass.description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                      ),
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                  currentClass.time.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                      ),
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
