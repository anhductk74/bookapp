import 'package:bookapp/services/UserService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bookapp/views/home/home.dart';
import 'package:page_transition/page_transition.dart';
import 'login.dart'; // Import Login screen

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final UserService userService = UserService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      // Tạo UID ngẫu nhiên cho người dùng
      String uid = DateTime.now()
          .millisecondsSinceEpoch
          .toString(); // UID đơn giản, có thể thay bằng cách khác

      // Tạo đối tượng người dùng
      final user = {
        'uid': uid,
        'name': name,
        'email': email,
        'password': password,
      };

      // Lưu thông tin người dùng vào Firestore
      await _firestore.collection('users').doc(uid).set(user);
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      var userDoc = querySnapshot.docs[0];

      userService.saveUserData(
          userDoc['uid'], userDoc['name'], userDoc['email']);
      // final localStorage = LocalStorage('user_data');
      // localStorage.setItem('user', json.encode(user));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng nhập thành công')),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng ký thành công')),
      );

      // Sau khi đăng ký thành công, chuyển sang màn hình Home
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home(user: user)),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi đăng ký: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05),
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome!",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 21,
                          color: Color(0xFF33bf2e),
                          fontFamily: "Poppins-Light",
                        ),
                      ),
                      Text(
                        "Create your account to get started.",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.black45,
                          fontFamily: "Poppins-Light",
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05),
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Text("Full Name",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02,
                              fontFamily: "Poppins-Regular",
                              height: 1.4)),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01),
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your full name',
                          hintStyle: TextStyle(
                            fontFamily: "Poppins-Regular",
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Name is required";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02),
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Text("Email address",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02,
                              fontFamily: "Poppins-Regular",
                              height: 1.4)),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01),
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your email address',
                          hintStyle: TextStyle(
                            fontFamily: "Poppins-Regular",
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Email address is required";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02),
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Text("Password",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02,
                              fontFamily: "Poppins-Regular",
                              height: 1.4)),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01),
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(
                            fontFamily: "Poppins-Regular",
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password is required";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF33bf2e), // Màu nền
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Bo tròn góc
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins-Light",
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        signUpUser();
                      }
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(
                            fontFamily: "Poppins-Regular", fontSize: 14),
                      ),
                      InkWell(
                        child: const Text(
                          "Log In",
                          style: TextStyle(
                              fontFamily: "Poppins-Regular",
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        ),
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: const LoginScreen()),
                              (route) => false);
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
