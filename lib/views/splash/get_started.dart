import 'package:flutter/material.dart';
import 'package:bookapp/views/auth/login.dart';
import 'package:page_transition/page_transition.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/get_started.png",
              width: MediaQuery.of(context).size.width * 0.50,
              height: MediaQuery.of(context).size.height * 0.50,
            ),
            Container(
              child: Column(
                children: [
                  const Text(
                    "Scan, Pay & Enjoy!",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: "Poppins-Light",
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF33bf2e),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.04,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: const Text(
                      "Scan products you want to buy at your favorite store and pay by your phone & enjoy happy, friendly Shopping!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontFamily: "Poppins-Light",
                          fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.08,
                  ),
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xFF33bf2e),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: const Text(
                        "Get Started",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins-Light",
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
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
    );
  }
}
