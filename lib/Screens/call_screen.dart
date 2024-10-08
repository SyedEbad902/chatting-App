import 'package:chatapp/Services/auth_service.dart';
import 'package:chatapp/Services/calling_service.dart';
import 'package:chatapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  Widget build(BuildContext context) {
    final callProvider = Provider.of<CallingService>(context);
    final authProvider = getIt<FirebaseAuthService>();
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        body: Stack(children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 1,
              width: double.infinity,
              child: Stack(fit: StackFit.expand, children: [
                Image.asset(
                  'assets/images/login-background.png',
                  fit: BoxFit
                      .cover,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                      top: MediaQuery.of(context).size.height * 0.07),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Calls",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ],
                  ),
                )
              ])),
          DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.8,
              maxChildSize: 0.8,
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
                      child: FutureBuilder(
                          future: callProvider
                              .getAllCalls(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text("No call logs found"));
                            }


                            return ListView.separated(
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  indent: 5,
                                  endIndent: 5,
                                  thickness: 1,
                                );
                              },
                              itemCount: callProvider.allCalls.length,
                              itemBuilder: (context, index) {
                                String userId =
                                    authProvider.credential.currentUser!.uid;
                                var call = callProvider.allCalls[index];
                                var callDateTime =
                                    callProvider.formatDate(call["timestamp"]);
                                var isOutgoing = call['callerID'] == userId;
                                var otherUser = isOutgoing
                                    ? call['inviteeName']
                                    : call['callerName'];
                                String text =
                                    isOutgoing ? '$otherUser' : '$otherUser';
                                return ListTile(
                                  leading: CircleAvatar(
                                      backgroundColor:
                                          const Color.fromARGB(255, 36, 36, 36),
                                      radius: 28,
                                      child: call['isVideoCall']
                                          ? SvgPicture.asset(
                                              "assets/images/videocall.svg",
                                              height: 28,
                                              width: 28,
                                              color: Colors.white,
                                            )
                                          : const Icon(
                                              Icons.call,
                                              size: 27,
                                              color: Colors.white,
                                            )),
                                  title: Text(
                                    text,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    "$callDateTime",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  trailing: Text(
                                    isOutgoing ? "Outgoing" : "Incomming",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                ),
                              );
                               
                            },
                          );
                        }
                      ),
                  ),
                );
              }
            )
        ]
      )
    );
  }
}
