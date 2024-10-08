import 'dart:async';

import 'package:chatapp/Screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_route_animator/page_route_animator.dart';
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

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          PageRouteAnimator(
            child: const LoginScreen(),
            routeAnimation: RouteAnimation.fadeAndScale,
            settings: const RouteSettings(),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          ));

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
                fit: StackFit
                    .expand,
                children: [
                  Image.asset(
                    'assets/images/login-background.png', 
                    fit: BoxFit
                        .cover,
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
                          const Text(
                              "Stay connected\nwith your friends\nfamily",
                              style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ))
                ])));
  }
}
