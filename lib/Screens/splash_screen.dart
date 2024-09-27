import 'dart:async';

import 'package:chatapp/Screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool> whereToGo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () async {
      bool isLoggedIn = await whereToGo();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  // isLoggedIn ? MessageScreen() :
                  LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 34, 34, 34),
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
                fit: StackFit
                    .expand, // This makes the image cover the entire screen
                children: [
                  Image.asset(
                    'assets/images/login-background.png', // Replace with your image path
                    fit: BoxFit
                        .cover, // This makes the image fill the screen while maintaining its aspect ratio
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 30, left: 15, right: 15, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("BEEP CHAT",
                              style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          SvgPicture.asset('assets/images/login.svg'),
                          Text("Stay connected\nwith your friends\nfamily",
                              style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ))
                ])));
  }
}
