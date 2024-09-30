import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/models/class.dart';
import 'package:gym_app/models/trainer.dart';
import 'package:gym_app/screens/capacity.dart';
import 'package:gym_app/screens/gym_classes.dart';
import 'package:gym_app/screens/profilepage.dart';
import 'package:gym_app/screens/trainer_list.dart';
import 'package:gym_app/widgets/button_one.dart';
import 'package:gym_app/widgets/button_two.dart';
import 'package:gym_app/widgets/image_placeholder.dart';
import 'package:gym_app/widgets/trainer_card.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<String> imageList = [
    'assets/images/a.jpg',
    'assets/images/b.jpg',
    'assets/images/c.webp',
  ];

  final List<Trainer> trainerList = [
    Trainer(
        name: "Ling",
        experienceYears: 12,
        rating: 5,
        imageUrl: 'assets/images/c.webp'),
    Trainer(
        name: "Supriono",
        experienceYears: 4,
        rating: 4.8,
        imageUrl: 'assets/images/a.jpg'),
    Trainer(
        name: "Supriono",
        experienceYears: 4,
        rating: 4.8,
        imageUrl: 'assets/images/a.jpg'),
    Trainer(
        name: "Supriono",
        experienceYears: 4,
        rating: 4.8,
        imageUrl: 'assets/images/a.jpg'),
  ];

  final List<Class> classList = [
    Class(
      title: "Zumba",
      description: "Zumba",
      time: DateTime.now(),
      imageUrl: 'assets/images/b.jpg',
    ),
    Class(
      title: "Zumba",
      description: "Zumba",
      time: DateTime.now(),
      imageUrl: 'assets/images/b.jpg',
    ),
    Class(
      title: "Zumba",
      description: "Zumba",
      time: DateTime.now(),
      imageUrl: 'assets/images/b.jpg',
    ),
    Class(
      title: "Zumba",
      description: "Zumba",
      time: DateTime.now(),
      imageUrl: 'assets/images/b.jpg',
    ),
  ];

  var _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  Timer? _timer;
  late List<Widget> _pages;

  // selected index for Bottom NavBar
  int _selectedIndex = 0;

  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return homePageContent();
      case 1:
        return const Profilepage();
      case 2:
        return GymClassesScreen(
          classList: classList,
        );
      case 3:
        return TrainerListScreen(
          trainerList: trainerList,
        );
      default:
        return homePageContent();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        // Ensure PageController is still active
        if (_pageController.page == imageList.length - 1) {
          _pageController.animateToPage(0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn);
        } else {
          _pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _pages = List.generate(
      imageList.length,
      (index) => ImagePlaceholder(ImagePath: imageList[index]),
    );
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _getSelectedPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            backgroundColor: Colors.blue,
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            backgroundColor: Colors.blue,
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Classes',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_people),
            label: 'Trainers',
            backgroundColor: Colors.blue,
          ),
        ],
        backgroundColor: Colors.blue,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade300,
        type: BottomNavigationBarType.shifting,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget homePageContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 4,
                  child: PageView.builder(
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      return _pages[index];
                    },
                    itemCount: imageList.length,
                    onPageChanged: (value) {
                      setState(() {
                        _currentPage = value;
                      });
                    },
                  ),
                ),
                // Code for Page Indicator
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: InkWell(
                            onTap: () {
                              _pageController.animateToPage(index,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                            },
                            child: CircleAvatar(
                              radius: 4,
                              backgroundColor: _currentPage == index
                                  ? Colors.yellow
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ButtonOne(
            text: "See Current Gym Capacity",
            icon: const Icon(Icons.people),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CapacityScreen()));
            },
          ),
          ButtonOne(
            text: "Workout Videos at Home",
            icon: const Icon(Icons.sports_gymnastics),
            onTap: () {},
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Booking kelas sekarang",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        "Berdasarkan lokasi gym yang anda pilih",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                    },
                    child: Text(
                      "Lihat Semua",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 3.5,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: classList.length,
                itemBuilder: (context, index) {
                  final currentClass = classList[index];
                  return ButtonTwo(
                    text: currentClass.title,
                    imageUrl: currentClass.imageUrl,
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade300,
                  Colors.blue.shade700,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2.7,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          child: Text(
                            "Pilih trainer anda",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 3;
                            });
                          },
                          child: Text(
                            "Lihat Semua",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 3.5,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: trainerList.length,
                          itemBuilder: (context, index) {
                            final trainer = trainerList[index];
                            return ButtonTwo(
                              text: trainer.name,
                              imageUrl: trainer.imageUrl,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
