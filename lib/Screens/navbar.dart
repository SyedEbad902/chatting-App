import 'package:chatapp/Screens/call_screen.dart';
import 'package:chatapp/Screens/home_screen.dart';
import 'package:chatapp/Screens/stories_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyNavBar extends StatefulWidget {
  const MyNavBar({super.key});

  @override
  State<MyNavBar> createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {
  int currentIndex = 0;
  List screens = [
    const MessageScreen(),
    const StoriesScreen(),
    const CallScreen(),
    const Scaffold(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        height: 80,
        color: Colors.white,
        clipBehavior: Clip.antiAliasWithSaveLayer,
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
                Text(
                  "Message",
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
                    });
                  },
                  child: SvgPicture.asset(
                    'assets/images/search-icon.svg',
                    height: 28,
                    width: 28,
                    color: currentIndex == 1
                        ? Colors.black
                        : const Color.fromARGB(255, 129, 129, 129),

                    // color: Colors.amber,
                  ),
                ),
                Text(
                  "Search",
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
                    });
                  },
                  child: Icon(
                    Icons.person,
                    size: 28,
                    color: currentIndex == 3
                        ? Colors.black
                        : const Color.fromARGB(255, 129, 129, 129),
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
      body: screens[currentIndex],
    );
  }
}
