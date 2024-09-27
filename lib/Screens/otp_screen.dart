import 'package:chatapp/Screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

class VerificationScreen extends StatefulWidget {
  final String verificationid;
  const VerificationScreen({super.key, required this.verificationid});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool _onEditing = true;
  String? _code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // print(_code);
            try {
              if (_code != null) {
                final cred = PhoneAuthProvider.credential(
                    verificationId: widget.verificationid, smsCode: _code!);
                await FirebaseAuth.instance.signInWithCredential(cred);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MessageScreen()));
              } else {
                print("enter code");
              }
            } catch (e) {
              print(e.toString());
            }
          },
          shape: const CircleBorder(),
          backgroundColor: const Color(0xff53B175),
          child: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 20,
          ),
        ),
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
                    "Enter Your Verification Code",
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
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(top: 30, left: 15, bottom: 40),
                          child: Text(
                            "We have sent an OTP to your phone\nplease verify",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.normal),
                          ),
                        ),
                        Align(
                          // alignment: Alignment.center,
                          child: VerificationCode(
                            fullBorder: true,
                            padding: EdgeInsets.all(5),

                            itemSize: MediaQuery.of(context).size.width * 0.12,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Color.fromARGB(255, 0, 0, 0)),
                            keyboardType: TextInputType.number,
                            underlineColor: Color.fromARGB(255, 0, 0,
                                0), // If this is null it will use primaryColor: Colors.red from Theme
                            length: 6,
                            cursorColor: Color.fromARGB(255, 0, 0,
                                0), // If this is null it will default to the ambient
                            // clearAll is NOT required, you can delete it
                            // takes any widget, so you can implement your design
                            clearAll: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'clear all',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    // decoration: TextDecoration.underline,
                                    color: Colors.black),
                              ),
                            ),
                            margin: const EdgeInsets.all(2),
                            onCompleted: (String value) {
                              setState(() {
                                _code = value;
                              });
                            },
                            onEditing: (bool value) {
                              setState(() {
                                _onEditing = value;
                              });
                              if (!_onEditing) FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Center(
                        //     child: _onEditing
                        //         ? const Text('Please enter full code')
                        //         : Text('Your code: $_code'),
                        //   ),
                        // ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Resend code",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              })
        ]));

    //  Scaffold(
    //     floatingActionButton: FloatingActionButton(
    //       onPressed: () {
    //         // Navigator.push(
    //         //     context,
    //         //     MaterialPageRoute(
    //         //         builder: (context) => const ()));
    //       },
    //       shape: const CircleBorder(),
    //       backgroundColor: const Color(0xff53B175),
    //       child: const Icon(
    //         Icons.arrow_forward_ios,
    //         color: Colors.white,
    //         size: 20,
    //       ),
    //     ),
    //     backgroundColor: Colors.white,
    //     body: Padding(
    //         padding: const EdgeInsets.all(10.0),
    //         child: GestureDetector(
    //           onTap: () {
    //             FocusScope.of(context).unfocus();
    //           },
    //           child: SingleChildScrollView(
    //             child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Stack(
    //                       // Aligns the icon to the center of the image
    //                       children: <Widget>[
    //                         // Image widget
    //                         SizedBox(
    //                             height:
    //                                 MediaQuery.of(context).size.height * 0.2,
    //                             width: double.infinity,
    //                             child: Image.asset(
    //                               'assets/images/mask-group.png',
    //                               // height: 400,
    //                               // width: 400,
    //                             )),
    //                         Positioned.fill(
    //                           child: Align(
    //                             alignment: Alignment.center,
    //                             child: Container(
    //                               width: double.infinity,
    //                               height: 230,
    //                               decoration: BoxDecoration(
    //                                 color: Colors.white.withOpacity(
    //                                     0.7), // Slight opacity for the glass
    //                                 borderRadius: BorderRadius.circular(20),
    //                                 border: Border.all(
    //                                   color: Colors.white.withOpacity(0.2),
    //                                 ),
    //                               ),
    //                               child: ClipRRect(
    //                                 borderRadius: BorderRadius.circular(20),
    //                                 child: BackdropFilter(
    //                                   filter: ImageFilter.blur(
    //                                       sigmaX: 10,
    //                                       sigmaY: 10), // Blur effect
    //                                   child: Container(
    //                                     alignment: Alignment.center,
    //                                     color: Colors.white.withOpacity(
    //                                         0.1), // Frosted glass color
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                         // Icon widget
    //                         Container(
    //                           padding: const EdgeInsets.only(top: 50, left: 15),
    //                           child: const Icon(
    //                             Icons.arrow_back_ios,
    //                             color: Colors.black,
    //                             size: 25.0, // Size of the icon
    //                           ),
    //                         ),
    //                       ]),
    // /                  const
    // Padding(
    //                     padding: EdgeInsets.only(left: 15, bottom: 15),
    //                     child: Text(
    //                       "Enter your 4-digit code",
    //                       style: TextStyle(
    //                           fontSize: 24, fontWeight: FontWeight.normal),
    //                     ),
    //                   ),
    //                   Align(
    //                     alignment: Alignment.center,
    //                     child: VerificationCode(
    //                       textStyle: Theme.of(context)
    //                           .textTheme
    //                           .bodyLarge!
    //                           .copyWith(color: const Color(0xff53B175)),
    //                       keyboardType: TextInputType.number,
    //                       underlineColor: const Color(
    //                           0xff53B175), // If this is null it will use primaryColor: Colors.red from Theme
    //                       length: 4,
    //                       cursorColor: Colors
    //                           .blue, // If this is null it will default to the ambient
    //                       // clearAll is NOT required, you can delete it
    //                       // takes any widget, so you can implement your design
    //                       clearAll: const Padding(
    //                         padding: EdgeInsets.all(8.0),
    //                         child: Text(
    //                           'clear all',
    //                           style: TextStyle(
    //                               fontSize: 14.0,
    //                               // decoration: TextDecoration.underline,
    //                               color: Color(0xff53B175)),
    //                         ),
    //                       ),
    //                       margin: const EdgeInsets.all(12),
    //                       onCompleted: (String value) {
    //                         setState(() {
    //                           _code = value;
    //                         });
    //                       },
    //                       onEditing: (bool value) {
    //                         setState(() {
    //                           _onEditing = value;
    //                         });
    //                         if (!_onEditing) FocusScope.of(context).unfocus();
    //                       },
    //                     ),
    //                   ),
    //                   Padding(
    //                     padding: const EdgeInsets.all(8.0),
    //                     child: Center(
    //                       child: _onEditing
    //                           ? const Text('Please enter full code')
    //                           : Text('Your code: $_code'),
    //                     ),
    //                   ),
    //                   const Padding(
    //                     padding: EdgeInsets.all(8.0),
    //                     child: Center(
    //                       child: Text(
    //                         "Resend code",
    //                         style: TextStyle(
    //                             fontSize: 15, color: Color(0xff53B175)),
    //                       ),
    //                     ),
    //                   )
    //                 ]),
    //           ),
    //         )));
  }
}
