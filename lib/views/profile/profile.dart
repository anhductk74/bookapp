import 'dart:developer';

import 'package:bookapp/services/UserService.dart';
import 'package:bookapp/views/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:bookapp/views/profile/change_password.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserService userService = UserService();
  String? userId;
  String? name;
  String? email;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    Map<String, String> userData = await userService.getUserData();
    setState(() {
      userId = userData['uid'];
      name = userData['name'];
      email = userData['email'];
    });

    if (userData.isEmpty) {
      log("User data is not available. Please log in.");
    }
  }

  Future<void> logout() async {
    await userService.logout();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You have logged out successfully!')),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Widget profileOption(
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        width: MediaQuery.of(context).size.width * 0.80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Align items to the left
          children: [
            Icon(icon, size: 30, color: const Color(0xFF33bf2e)),
            const SizedBox(width: 16), // Space between icon and text
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to the left
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.black)),
                Text(subtitle, style: const TextStyle(color: Colors.black45)),
              ],
            ),
            const Spacer(), // Ensures the arrow icon aligns to the right
            const Icon(Icons.arrow_forward_ios_outlined, size: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontFamily: "Poppins-Light"),
        ),
        backgroundColor: const Color(0xFF33bf2e),
        centerTitle: true, // Centers the title
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Picture and Info
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0), // Added vertical padding
                    child: ClipOval(
                      child: Image.asset(
                        "assets/user.png",
                        width: MediaQuery.of(context).size.width *
                            0.25, // Original size
                        height: MediaQuery.of(context).size.width *
                            0.25, // Original size
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$name",
                        style: const TextStyle(
                          fontFamily: "Poppins-Light",
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      Text("$email",
                          style: const TextStyle(fontFamily: "Poppins-Light")),
                      const SizedBox(height: 8),
                      Text(
                        "View My Profile",
                        style: TextStyle(
                          fontFamily: "Poppins-Light",
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF33bf2e),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Profile options
              profileOption(
                icon: Icons.lock,
                title: "Change Password",
                subtitle: "Change your password",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const ChangePassword()),
                  );
                },
              ),
              const Divider(color: Colors.black12, thickness: 0.5),

              profileOption(
                icon: Icons.pin_drop,
                title: "Locations",
                subtitle: "Add your locations",
                onTap: () {
                  // Add functionality for locations
                },
              ),
              const Divider(color: Colors.black12, thickness: 0.5),

              profileOption(
                icon: Icons.facebook,
                title: "Add Social Account",
                subtitle: "Add Facebook, Twitter etc.",
                onTap: () {
                  // Add functionality for social accounts
                },
              ),
              const Divider(color: Colors.black12, thickness: 0.5),

              profileOption(
                icon: Icons.share_outlined,
                title: "Refer to Friends",
                subtitle: "Get \$10 for referring friends",
                onTap: () {
                  // Add functionality for referrals
                },
              ),
              const Divider(color: Colors.black12, thickness: 0.5),

              profileOption(
                icon: Icons.star,
                title: "Rate Us",
                subtitle: "Rate us on the PlayStore or AppStore",
                onTap: () {
                  // Add functionality for rating
                },
              ),
              const Divider(color: Colors.black12, thickness: 0.5),

              // Logout Option
              profileOption(
                icon: Icons.lock,
                title: "Log Out",
                subtitle: "Thanks, see you again!",
                onTap: () {
                  logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
