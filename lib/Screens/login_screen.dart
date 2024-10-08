import 'package:chatapp/Screens/signup_screen.dart';
import 'package:chatapp/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<FirebaseAuthService>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            fit:
                StackFit.expand,
            children: [
              Image.asset(
                'assets/images/login-background.png', 
                fit: BoxFit
                    .cover,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 30, left: 15, right: 15, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    const Text("Login",
                        style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                   
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 15, bottom: 8),
                            child: const Text(
                              "Email",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.085,
                            width: MediaQuery.of(context).size.width * 0.85,
                            padding: const EdgeInsets.only(
                                left: 18, top: 8, bottom: 8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 219, 217, 217)),
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white),
                            child: TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                  border: InputBorder
                                      .none, // Removes the bottom line
                                  hintText: 'Enter your Email',
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 15, bottom: 8),
                            child: const Text(
                              "Password",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 18, top: 8, bottom: 8),
                            height: MediaQuery.of(context).size.height * 0.085,
                            width: MediaQuery.of(context).size.width * 0.85,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 219, 217, 217)),
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white),
                            child: TextField(
                              controller: passwordController,
                              decoration: const InputDecoration(
                                  border: InputBorder
                                      .none,
                                  hintText: 'Enter your Password',
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.085,
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: ElevatedButton(
                        onPressed: () async {
                         
                          authProvider.signinUser(emailController.text.trim(),
                              passwordController.text.trim(), context);
                         
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30), // Adjust radius as needed
                          ),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Dont have an account?  ",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupScreen()));
                            },
                            child: const Text("Sign Up",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

//
    );
  }
}