import 'package:chatapp/Services/validation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final validationProvider = Provider.of<ValidationProvider>(context);

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
                    top: 30, left: 15, right: 15, bottom: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      const Text("Sign Up",
                          style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),

                      // ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 15, bottom: 8),
                              child: const Text(
                                "Email",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.085,
                              width: MediaQuery.of(context).size.width * 0.85,
                              padding: const EdgeInsets.only(
                                  left: 18, top: 8, bottom: 8),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 219, 217, 217)),
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white),
                              child: TextFormField(
                                
                                controller: validationProvider.emailController,
                                decoration: const InputDecoration(
                                    border: InputBorder
                                        .none, // Removes the bottom line
                                    hintText: 'Enter your Email',
                                    hintStyle: TextStyle(
                                        color: Colors.black, fontSize: 16)),
                              ),
                            ),
                            if (validationProvider.emailError != null)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20.0, top: 5.0),
                                child: Text(
                                  validationProvider.emailError!,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 224, 65, 53),
                                      fontSize: 12),
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
                              padding:
                                  const EdgeInsets.only(left: 15, bottom: 8),
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
                              height:
                                  MediaQuery.of(context).size.height * 0.085,
                              width: MediaQuery.of(context).size.width * 0.85,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 219, 217, 217)),
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white),
                              child: TextFormField(
                                obscureText: true,
                                controller: validationProvider.passwordController,
                                decoration: const InputDecoration(
                                    border: InputBorder
                                        .none, // Removes the bottom line
                                    hintText: 'Enter Password',
                                    hintStyle: TextStyle(
                                        color: Colors.black, fontSize: 16)),
                              ),
                            ),
                            if (validationProvider.passwordError != null)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20.0, top: 5.0),
                                child: Text(
                                  validationProvider.passwordError!,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 224, 65, 53),
                                      fontSize: 12),
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
                              padding:
                                  const EdgeInsets.only(left: 15, bottom: 8),
                              child: const Text(
                                "Confirm Password",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 18, top: 8, bottom: 8),
                              height:
                                  MediaQuery.of(context).size.height * 0.085,
                              width: MediaQuery.of(context).size.width * 0.85,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 219, 217, 217)),
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white),
                              child: TextFormField(
                                controller: validationProvider.confirmPasswordController,
                                obscureText: true,
                              
                                decoration: const InputDecoration(
                                    border: InputBorder
                                        .none, // Removes the bottom line
                                    hintText: 'Confirm Password',
                                    hintStyle: TextStyle(
                                        color: Colors.black, fontSize: 16)),
                              ),
                            ),
                            if (validationProvider.confirmPasswordError != null)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20.0, top: 5.0),
                                child: Text(
                                  validationProvider.confirmPasswordError!,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 224, 65, 53),
                                      fontSize: 12),
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
                          onPressed: () {
                            // var number = code! + numberController.text;
                            validationProvider.submitForm(context);
                            // print(number);
                            print('hello');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  30), // Adjust radius as needed
                            ),
                          ),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
