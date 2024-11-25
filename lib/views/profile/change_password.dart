import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(fontFamily: 'Poppins-Light'),
        ),
        backgroundColor: const Color(0xFF33bf2e),
      ),
      body: Container(
        child: const Text('body'),
      ),
    );
  }
}
