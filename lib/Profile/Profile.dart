import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_function.dart';

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

  @override
  void initState() {
    super.initState();
    ProfileFunctions.fetchUserData(setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: ProfileFunctions.imageUrl.isNotEmpty
                            ? NetworkImage(ProfileFunctions.imageUrl)
                            : null,
                        child: ProfileFunctions.imageUrl.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 60,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        ProfileFunctions.name.isNotEmpty
                            ? ProfileFunctions.name.toUpperCase()
                            : 'LOADING...',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        ProfileFunctions.email.isNotEmpty
                            ? ProfileFunctions.email
                            : 'LOADING...',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 10),
                    _buildProfileInfoRow('PREVIOUS WORK EXPERIENCE',
                        ProfileFunctions.experience),
                    _buildProfileInfoRow('BIRTHDAY', ProfileFunctions.birthday),
                    _buildProfileInfoRow(
                        'COOKING LEVEL', ProfileFunctions.cookingLevel),
                    _buildProfileInfoRow('COOKING PREFERENCE',
                        ProfileFunctions.cookingPreference),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase() + ':',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(
            value.isNotEmpty ? value.toUpperCase() : 'LOADING...',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
