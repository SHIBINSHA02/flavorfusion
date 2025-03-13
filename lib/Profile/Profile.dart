import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_function.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  String? imagePath;

  @override
  void initState() {
    super.initState();
    ProfileFunctions.fetchUserData(setState);
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imagePath = image.path;
      });
      await _uploadImage(image.path);
    }
  }

  Future<void> _uploadImage(String path) async {
    File imageFile = File(path);
    Uint8List imageBytes = await imageFile.readAsBytes();

    String userId = FirebaseAuth.instance.currentUser!.uid;
    Reference ref =
        FirebaseStorage.instance.ref().child('user_images/$userId.jpg');

    try {
      await ref.putData(imageBytes);
      String downloadUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'imageUrl': downloadUrl,
      });

      ProfileFunctions.imageUrl = downloadUrl;
      setState(() {});
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              ProfileFunctions.showEditDialog(
                context,
                setState,
                nameController,
                emailController,
                experienceController,
                birthdayController,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              //Keep scrollable in case content is too large.
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 60, //Reduced Radius
                              backgroundImage: imagePath != null
                                  ? FileImage(File(imagePath!))
                                  : ProfileFunctions.imageUrl.isNotEmpty
                                      ? NetworkImage(ProfileFunctions.imageUrl)
                                      : null,
                              child: ProfileFunctions.imageUrl.isEmpty &&
                                      imagePath == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 60, //Reduced Icon Size
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue.shade200.withOpacity(0.7),
                              ),
                              padding:
                                  const EdgeInsets.all(4), //Reduced padding
                              child: const Icon(Icons.camera_alt,
                                  size: 18,
                                  color: Colors.white), //Reduced Icon Size
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15), //Reduced Spacing
                      Card(
                        elevation: 3, //Reduced Elevation
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), //Reduced Radius
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0), //Reduced Padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildProfileInfoRow(
                                  'Name', ProfileFunctions.name),
                              _buildProfileInfoRow(
                                  'Email', ProfileFunctions.email),
                              _buildProfileInfoRow(
                                  'Experience', ProfileFunctions.experience),
                              _buildProfileInfoRow(
                                  'Birthday', ProfileFunctions.birthday),
                              _buildProfileInfoRow('Cooking Level',
                                  ProfileFunctions.cookingLevel),
                              _buildProfileInfoRow('Cooking Preference',
                                  ProfileFunctions.cookingPreference),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20), //Reduced Spacing
                      ElevatedButton(
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12), //Reduced Padding
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), //Reduced Radius
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                        child: const Text('Logout',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white)), //Reduced Font Size
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0), //Reduced Padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14, //Reduced Font Size
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 3), //Reduced SizedBox
          Text(
            value.isNotEmpty ? value : 'Loading...',
            style: const TextStyle(fontSize: 16), //Reduced Font Size
          ),
          const Divider(
              height: 15, thickness: 0.8, color: Colors.grey), //Reduced Divider
        ],
      ),
    );
  }
}
