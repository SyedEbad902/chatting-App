import 'package:chatapp/Screens/chat_screen.dart';
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
    const Scaffold(),
    const Scaffold(),
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
            // IconButton(
            //   onPressed: () {
            //     setState(() {
            //       currentIndex = 0;
            //     });
            //   },
            //   icon: Icon(
            //     Icons.message,
            //     size: 30,
            //     color: currentIndex == 0 ? Colors.blue : Colors.grey,
            //   ),
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    'assets/images/message-icon.svg',
                    height: 28,
                    width: 28,
                    // color: Colors.amber,
                  ),
                ),
                const Text(
                  "Message",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    'assets/images/search-icon.svg',
                    height: 28,
                    width: 28,
                    // color: Colors.amber,
                  ),
                ),
                const Text(
                  "Search",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    'assets/images/call-icon.svg',
                    height: 28,
                    width: 28,
                    // color: Colors.amber,
                  ),
                ),
                const Text(
                  "Calls",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Icon(
                    Icons.person,
                    size: 28,
                    color: currentIndex == 4 ? Colors.blue : Colors.black,
                  ),
                ),
                const Text(
                  "Profile",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
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
