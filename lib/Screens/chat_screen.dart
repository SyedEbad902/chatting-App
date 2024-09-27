import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff414A4C),
        body: Stack(children: [
          
          SizedBox(
              height: MediaQuery.of(context).size.height * 1,
              // decoration: BoxDecoration(border: Border(bottom: Bo)),
              width: double.infinity,
              child: Stack(fit: StackFit.expand, children: [
                Image.asset(
                  'assets/images/login-background.png', // Replace with your image path
                  fit: BoxFit
                      .cover, // This makes the image fill the screen while maintaining its aspect ratio
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      top: MediaQuery.of(context).size.height * 0.07),
                  child: const Text(
                    "Welcome Ebad!",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                )
              ])),

          DraggableScrollableSheet(
              initialChildSize: 0.8, // 30% of the screen height
              minChildSize:
                  0.8, // Minimum size (fixed at 30% of the screen height)
              maxChildSize:
                  0.8, // Maximum size (fixed at 30% of the screen height)
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return const Divider(
                            color: Color.fromARGB(255, 224, 223, 223),
                            indent: 10,
                            endIndent: 10,
                          );
                        },
                        controller: scrollController,
                        itemCount: 20,
                        itemBuilder: (BuildContext context, int index) {
                          return const ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(
                                'assets/images/user1.png',
                                // height: 50,
                                // width: 50,
                              ),
                            ),
                            title: Text(
                              "Syed Ebad",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "oky sure",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "12:55",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  Icons.done_all,
                                  size: 17,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
                    //  Column(
                    //   children: [
                    //     Container(
                    //       height: MediaQuery.of(context).size.height * 0.2,
                    //       // decoration: BoxDecoration(border: Border(bottom: Bo)),
                    //       width: double.infinity,
                    //       child: Stack(
                    //         fit: StackFit.passthrough,
                    //         children: [
                    //           Image.asset(
                    //             'assets/images/login-background.png', // Replace with your image path
                    //             fit: BoxFit
                    //                 .cover, // This makes the image fill the screen while maintaining its aspect ratio
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    );
              })
        ]));
  }
}
