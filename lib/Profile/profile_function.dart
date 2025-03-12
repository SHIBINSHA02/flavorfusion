import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileFunctions {
  static String name = '';
  static String email = '';
  static String experience = '';
  static String birthday = '';
  static String cookingLevel = 'Beginner';
  static String cookingPreference = 'Cooking';
  static String imageUrl = ''; // Initialize as empty

  static Future<void> fetchUserData(Function setState) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      name = userDoc['name'] ?? '';
      email = userDoc['email'] ?? '';
      experience = userDoc['experience'] ?? '';
      birthday = userDoc['birthday'] ?? '';
      cookingLevel = userDoc['cookingLevel'] ?? 'Beginner';
      cookingPreference = userDoc['cookingPreference'] ?? 'Cooking';
      imageUrl = userDoc['imageUrl'] ?? ''; // Get imageUrl from Firestore
      setState(() {});
    }
  }

  static Future<void> uploadImage(Function setState) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String userId = FirebaseAuth.instance.currentUser!.uid;
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('user_images/$userId.jpg');

      await ref.putFile(imageFile);
      String downloadUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'imageUrl': downloadUrl});

      imageUrl = downloadUrl;
      setState(() {});
    }
  }

  static void showEditDialog(
    BuildContext context,
    Function setState,
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController experienceController,
    TextEditingController birthdayController,
  ) {
    nameController.text = name;
    emailController.text = email;
    experienceController.text = experience;
    birthdayController.text = birthday;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: experienceController,
                  decoration:
                      const InputDecoration(labelText: 'Previous Work Experience'),
                ),
                TextField(
                  controller: birthdayController,
                  decoration:
                      const InputDecoration(labelText: 'Birthday (YYYY-MM-DD)'),
                ),
                DropdownButton<String>(
                  value: cookingLevel,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      cookingLevel = newValue;
                      setState(() {});
                    }
                  },
                  items: <String>['Beginner', 'Intermediate', 'Advanced']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: const Text('Select Cooking Level'),
                ),
                DropdownButton<String>(
                  value: cookingPreference,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      cookingPreference = newValue;
                      setState(() {});
                    }
                  },
                  items: <String>['Cooking', 'Making']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: const Text('Select Cooking Preference'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String userId = FirebaseAuth.instance.currentUser!.uid;
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .set({
                  'name': nameController.text,
                  'email': emailController.text,
                  'experience': experienceController.text,
                  'birthday': birthdayController.text,
                  'cookingLevel': cookingLevel,
                  'cookingPreference': cookingPreference,
                  'imageUrl': imageUrl,
                });
                Navigator.of(context).pop();
                fetchUserData(setState);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}