import 'package:flutter/material.dart';
import 'package:bookapp/views/profile/change_password.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  getUser() async {
    // log(json.encode(user));
  }

  @override
  void initState() {
    super.initState();
    // getUser();
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
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/user.png",
                      width: MediaQuery.of(context).size.width * 0.32,
                      height: MediaQuery.of(context).size.height * 0.22,
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(left: 2),
                    //   alignment: Alignment.center,
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         "${TokenProvider().getUser()?.}",
                    //         style: const TextStyle(
                    //             fontFamily: "Poppins-Light",
                    //             color: Colors.black,
                    //             fontWeight: FontWeight.w800,
                    //             fontSize: 16),
                    //       ),
                    //       Text(
                    //         "${TokenProvider().getUser()?.email}",
                    //         style: TextStyle(fontFamily: "Poppins-Light"),
                    //       ),
                    //       Text(
                    //         "${TokenProvider().getUser()?.password}",
                    //         style: TextStyle(fontFamily: "Poppins-Light"),
                    //       ),
                    //       Text(
                    //         "View My Profile",
                    //         style: TextStyle(
                    //           fontFamily: "Poppins-Light",
                    //           fontWeight: FontWeight.w600,
                    //           color: Color(0xFF33bf2e),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              Container(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => const ChangePassword()),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.70,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.lock,
                                  size: 30,
                                  color: Color(0xFF33bf2e),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 30),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Change Password",
                                        style: TextStyle(
                                            fontFamily: "Poppins-Regular",
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        "Change your password",
                                        style: TextStyle(
                                            fontFamily: "Poppins-Regular",
                                            color: Colors.black45),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 20,
                                )
                              ],
                            ),
                            const Divider(
                              color: Colors.black12,
                              thickness: 0.5,
                              indent: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.70,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.pin_drop,
                                size: 30,
                                color: Color(0xFF33bf2e),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 60),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Locations",
                                      style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      "Add your locations",
                                      style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          color: Colors.black45),
                                    ),
                                    Divider(
                                      color: Colors.black45,
                                      thickness: 3,
                                      height: 5,
                                      indent: 25,
                                      endIndent: 25,
                                    )
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 20,
                              )
                            ],
                          ),
                          const Divider(
                            color: Colors.black12,
                            thickness: 0.5,
                            indent: 20,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.70,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.facebook,
                                size: 30,
                                color: Color(0xFF33bf2e),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Add Social Account",
                                      style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      "Add Facebook, Twitter etc",
                                      style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          color: Colors.black45),
                                    ),
                                    Divider(
                                      color: Colors.black45,
                                      thickness: 3,
                                      height: 5,
                                      indent: 25,
                                      endIndent: 25,
                                    )
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 20,
                              )
                            ],
                          ),
                          const Divider(
                            color: Colors.black12,
                            thickness: 0.5,
                            indent: 20,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.70,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.share_outlined,
                                size: 30,
                                color: Color(0xFF33bf2e),
                              ),
                              Container(
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Refer to Friends",
                                      style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      "Get \$10 for reffering friends",
                                      style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          color: Colors.black45),
                                    ),
                                    Divider(
                                      color: Colors.black45,
                                      thickness: 3,
                                      height: 5,
                                      indent: 25,
                                      endIndent: 25,
                                    )
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 20,
                              )
                            ],
                          ),
                          const Divider(
                            color: Colors.black12,
                            thickness: 0.5,
                            indent: 20,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.70,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.star,
                                size: 30,
                                color: Color(0xFF33bf2e),
                              ),
                              Container(
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Rate Us",
                                      style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      "Rate us playstore, appstore",
                                      style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          color: Colors.black45),
                                    ),
                                    Divider(
                                      color: Colors.black45,
                                      thickness: 3,
                                      height: 5,
                                      indent: 25,
                                      endIndent: 25,
                                    )
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 20,
                              )
                            ],
                          ),
                          const Divider(
                            color: Colors.black12,
                            thickness: 0.5,
                            indent: 20,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.70,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.book,
                                size: 30,
                                color: Color(0xFF33bf2e),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 50),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "FAQ",
                                      style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      "Asked any questions",
                                      style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          color: Colors.black45),
                                    ),
                                    Divider(
                                      color: Colors.black45,
                                      thickness: 3,
                                      height: 5,
                                      indent: 25,
                                      endIndent: 25,
                                    )
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 20,
                              )
                            ],
                          ),
                          const Divider(
                            color: Colors.black12,
                            thickness: 0.5,
                            indent: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
