// ignore_for_file: deprecated_member_use

import 'package:chatapp/Screens/call_screen.dart';
import 'package:chatapp/Screens/home_screen.dart';
import 'package:chatapp/Screens/stories_screen.dart';
import 'package:chatapp/Screens/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyNavBar extends StatefulWidget {
  const MyNavBar({super.key});

  @override
  State<MyNavBar> createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {
  int currentIndex = 0;
  List<Widget> screens = [
    const MessageScreen(),
    const StoriesScreen(),
    const CallScreen(),
    const UpdateProfile(),
  ];
  var pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        height: MediaQuery.of(context).size.height * 0.1,
        color: Colors.white,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Row(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = 0;
                        pageController.animateToPage(currentIndex,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.fastEaseInToSlowEaseOut);
                      });
                    },
                    child: SvgPicture.asset(
                      'assets/images/message-icon.svg',
                      height: 28,
                      width: 28,
                      color: currentIndex == 0
                          ? Colors.black
                          : const Color.fromARGB(255, 129, 129, 129),

                      // color: Colors.amber,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Chats",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: currentIndex == 0
                          ? Colors.black
                          : const Color.fromARGB(255, 129, 129, 129),
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = 1;
                        pageController.animateToPage(currentIndex,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      });
                    },
                    child: SvgPicture.asset(
                      'assets/images/story-icon.svg',
                      height: 28,
                      width: 28,
                      color: currentIndex == 1
                          ? Colors.black
                          : const Color.fromARGB(255, 129, 129, 129),

                      // color: Colors.amber,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Stories",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: currentIndex == 1
                          ? Colors.black
                          : const Color.fromARGB(255, 129, 129, 129),
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = 2;
                        pageController.animateToPage(currentIndex,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      });
                    },
                    child: SvgPicture.asset(
                      'assets/images/call-icon.svg',
                      height: 28,
                      width: 28,
                      color: currentIndex == 2
                          ? Colors.black
                          : const Color.fromARGB(255, 129, 129, 129),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Calls",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: currentIndex == 2
                          ? Colors.black
                          : const Color.fromARGB(255, 129, 129, 129),
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = 3;
                        pageController.animateToPage(currentIndex,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      });
                    },
                    child: SvgPicture.asset(
                      'assets/images/profile-icon.svg',
                      height: 30,
                      width: 30,
                      color: currentIndex == 3
                          ? Colors.black
                          : const Color.fromARGB(255, 129, 129, 129),

                      // color: Colors.amber,
                    ),
                  ),
                  Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: currentIndex == 3
                          ? Colors.black
                          : const Color.fromARGB(255, 129, 129, 129),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      body: PageView(
        children: screens,
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      //  screens[currentIndex],
    );
  }
}
