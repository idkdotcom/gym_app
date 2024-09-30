import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/widgets/capacity_widget.dart';

class CapacityScreen extends StatelessWidget {
  const CapacityScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // SET GYM MAX CAPACITY HERE!!!
    const maxCapacity = 100;

    void updateCrowdStatus(int currentMembers, int maxCapacity) {
      double threshold = maxCapacity / 1.5;

      String crowdStatus =
          currentMembers > threshold ? "Crowded" : "Not Crowded";

      FirebaseFirestore.instance
          .collection('attendance')
          .doc('status')
          .update({
            'crowd': crowdStatus,
          });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Gym Capacity",
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.exit_to_app_outlined),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('attendance')
            .doc('status')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Text("Error Fetching Data");
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Text("No data found");
          }

          var data = snapshot.data!;
          int currentMembers = data['currentMembers'];
          updateCrowdStatus(currentMembers, maxCapacity);

          return Center(
            child: Column(
              children: [
                const SizedBox(height: 40,),
                GymCapacityWidget(
                    currentMembers: currentMembers, maxCapacity: maxCapacity),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Current Members in Gym',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$currentMembers',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          data['crowd'] == "Not Crowded"
                              ? "Not Crowded"
                              : "Crowded",
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(
                                color: data['crowd'] == 'Crowded'
                                    ? Colors.red
                                    : Colors.green,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
