import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bookapp/views/auth/login.dart';
import 'package:bookapp/views/cart/cart.dart';
import 'package:bookapp/views/favorite/favorite.dart';
import 'package:bookapp/views/home/dashboard.dart';
import 'package:bookapp/views/profile/profile.dart';
import 'package:bookapp/services/userservice.dart';

class Home extends StatefulWidget {
  final Map<String, dynamic> user;

  const Home({super.key, required this.user});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  late String userName;
  UserService userService = UserService();
  String? userId;

  Future<void> getUserId() async {
    Map<String, String> userData = await userService.getUserData();
    userId = userData['uid'];
    setState(() {
      userId = userData['uid'];
    });

    if (userId == null) {
      log("User ID is not available. Please log in.");
    }
  }

  final List<Widget> _screens = [
    const Dashboard(),
    const Favorite(),
    const Cart(),
    const Profile(),
  ];

  @override
  void initState() {
    super.initState();
    userName = widget.user['name'] ?? 'No name';
    getUserId();
  }

  Future<bool> onWillPop() {
    if (currentIndex != 0) {
      setState(() {
        currentIndex = 0;
      });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  Future<void> logout() async {
    final userService = UserService();
    await userService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: onWillPop,
        child: _screens[
            currentIndex], // Điều này giúp tái tạo lại mỗi khi chuyển tab
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        onTap: (index) {
          setState(() {
            currentIndex = index; // Cập nhật index và làm mới màn hình
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/house.svg',
              color: (currentIndex == 0)
                  ? const Color(0xFF33bf2e)
                  : Colors.black38,
              height: MediaQuery.of(context).size.height * 0.035,
              width: MediaQuery.of(context).size.height * 0.035,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/favorite.svg',
              color: (currentIndex == 1)
                  ? const Color(0xFF33bf2e)
                  : Colors.black38,
              height: MediaQuery.of(context).size.height * 0.035,
              width: MediaQuery.of(context).size.height * 0.035,
            ),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/cart.svg',
              color: (currentIndex == 2)
                  ? const Color(0xFF33bf2e)
                  : Colors.black38,
              height: MediaQuery.of(context).size.height * 0.035,
              width: MediaQuery.of(context).size.height * 0.035,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/profile.svg',
              color: (currentIndex == 3)
                  ? const Color(0xFF33bf2e)
                  : Colors.black38,
              height: MediaQuery.of(context).size.height * 0.035,
              width: MediaQuery.of(context).size.height * 0.035,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
