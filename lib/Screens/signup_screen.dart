import 'package:chatapp/Screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  createUser(String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup Successful')),
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  final _formKey = GlobalKey<FormState>();

  // Controllers to get the text field values
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Simple email validation pattern
    String pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9.]+.[a-zA-Z]{2,4}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // Helper function to validate password strength
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Helper function to confirm password match
  String? _validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Please confirm your password';
    } else if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _passwordError;
  String? _emailError;
  String? _confirmPasswordError;
  // void _submitForm() {
  //   setState(() {
  //     // Manually validate the password when the user submits the form
  //     _passwordError = _validatePassword(_passwordController.text);
  //     _emailError = _validatePassword(_passwordController.text);
  //     _confirmPasswordError = _validatePassword(_passwordController.text);
  //   });
  // }
  void _submitForm() {
    setState(() {
      // Manually validate the fields
      _emailError = _validateEmail(_emailController.text);
      _passwordError = _validatePassword(_passwordController.text);
      _confirmPasswordError = _validateConfirmPassword(
          _passwordController.text, _confirmPasswordController.text);

      // If all fields are valid, show SnackBar
      if (_emailError == null &&
          _passwordError == null &&
          _confirmPasswordError == null) {
        createUser(_emailController.text, _passwordController.text);

        // print(_emailController.text);
        // print(_passwordController.text);
        // print(_confirmPasswordController.text);
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    });
  }

  // Function to submit the form after validation
  // void _submitForm() {
  //   setState(() {
  //     if (_formKey.currentState!.validate()) {
  //       // _passwordError = null;
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text('Signup Successful')));
  //     } else {
  //     _passwordError = _validatePassword(_passwordController.text);
  //           _emailError = _validatePassword(_passwordController.text);
  //           _confirmPasswordError = _validatePassword(_passwordController.text);
  //     }
  //   });
  // }
  //   // if (_formKey.currentState!.validate()) {
  //   //   // All validations passed
  //   //   ScaffoldMessenger.of(context).showSnackBar(
  //   //     SnackBar(content: Text('Signup Successful')),
  //   //   );
  //   //   // You can perform further actions, like calling an API here.
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 20, 20, 20),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            fit:
                StackFit.expand, // This makes the image cover the entire screen
            children: [
              Image.asset(
                'assets/images/login-background.png', // Replace with your image path
                fit: BoxFit
                    .cover, // This makes the image fill the screen while maintaining its aspect ratio
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 30, left: 15, right: 15, bottom: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              padding: EdgeInsets.only(left: 15, bottom: 8),
                              child: Text(
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
                                // validator: (value) {
                                //   final error = _validateEmail(value);
                                //   return null; // Always return null here
                                // },
                                controller: _emailController,
                                decoration: const InputDecoration(
                                    border: InputBorder
                                        .none, // Removes the bottom line
                                    hintText: 'Enter your Email',
                                    hintStyle: TextStyle(
                                        color: Colors.black, fontSize: 16)),
                              ),
                            ),
                            if (_emailError != null)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20.0, top: 5.0),
                                child: Text(
                                  _emailError!,
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
                              padding: EdgeInsets.only(left: 15, bottom: 8),
                              child: Text(
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
                                controller: _passwordController,
                                decoration: const InputDecoration(
                                    border: InputBorder
                                        .none, // Removes the bottom line
                                    hintText: 'Enter Password',
                                    hintStyle: TextStyle(
                                        color: Colors.black, fontSize: 16)),
                              ),
                            ),
                            if (_passwordError != null)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20.0, top: 5.0),
                                child: Text(
                                  _passwordError!,
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
                              padding: EdgeInsets.only(left: 15, bottom: 8),
                              child: Text(
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
                                controller: _confirmPasswordController,
                                obscureText: true,
                                // validator: (value) {
                                //   final error = _validateConfirmPassword(value);
                                //   return null; // Always return null here
                                // },
                                decoration: const InputDecoration(
                                    border: InputBorder
                                        .none, // Removes the bottom line
                                    hintText: 'Confirm Password',
                                    hintStyle: TextStyle(
                                        color: Colors.black, fontSize: 16)),
                              ),
                            ),
                            if (_confirmPasswordError != null)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20.0, top: 5.0),
                                child: Text(
                                  _confirmPasswordError!,
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
                            _submitForm();
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

//
    );
  }
}
