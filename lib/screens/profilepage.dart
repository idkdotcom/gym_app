import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  String username = '';
  TextEditingController _usernameController = TextEditingController();
  Timestamp? membershipEnd;
  String membershipStatus = '';
  bool isLoadingUsername = true;
  int membershipLeft = 0;
  File? _image;
  String? _profileImageUrl;
  bool isEditingUsername = false;

  final ImagePicker _picker = ImagePicker();

  void getFirebaseData() async {
    final user = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(user).get();

    if (mounted) {
      setState(() {
        username = userDoc['username'] as String? ?? '';
        membershipStatus = userDoc['memberStatus'] as String? ?? '';
        membershipEnd = userDoc['memberEnd'] as Timestamp?;
        membershipLeft = userDoc['monthsLeft'];
        isLoadingUsername = false;

        // Fetch profile image URL from Firestore if available
        _profileImageUrl = userDoc['profileImageUrl'] as String?;
      });
    }
  }

  void pickImage() async {
    var status = await Permission.storage.request();

    if (status.isGranted) {
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedImage == null) {
        return;
      }

      final imageFile = File(pickedImage.path);
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final storageRef =
          FirebaseStorage.instance.ref().child('profile_images').child('$userId.jpg');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL();

      // Update the profile image URL in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).update({'profileImageUrl': imageUrl});

      setState(() {
        _profileImageUrl = imageUrl;  // Use the URL from Firebase
        _image = imageFile;  // Optionally keep the local image
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Permission denied. Please allow access to the gallery",
          ),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: pickImage,
          ),
        ),
      );
    }
  }

  void updateUsername() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final newUsername = _usernameController.text;

    if (newUsername.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'username': newUsername});
    }

    setState(() {
      username = newUsername;
      isEditingUsername = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getFirebaseData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: FirebaseAuth.instance.signOut,
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: InkWell(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _image != null
                        ? FileImage(_image!)  // Local image if available
                        : (_profileImageUrl != null
                            ? NetworkImage(_profileImageUrl!)  // Firebase image URL
                            : null),
                    child: _image == null && _profileImageUrl == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isEditingUsername
                        ? Expanded(
                            child: TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: "Edit Username Here",
                                labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          )
                        : isLoadingUsername
                            ? const CircularProgressIndicator(
                                color: Colors.black,
                              )
                            : Text(
                                username,
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                    IconButton(
                      icon: Icon(
                        isEditingUsername ? Icons.check : Icons.edit,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        if (isEditingUsername) {
                          updateUsername();  // Save the new username
                        } else {
                          setState(() {
                            _usernameController.text = username;  // Ensure controller is set
                            isEditingUsername = true;  // Enter edit mode
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Membership Status: ",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    membershipStatus,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: membershipStatus == "Activated"
                            ? Colors.green
                            : Colors.red.shade500,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Membership Months Left: $membershipLeft",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 10),
              Text(
                "Membership End Date: ${membershipEnd != null ? DateFormat('yyyy-MM-dd').format(membershipEnd!.toDate()) : "Not Set"}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
