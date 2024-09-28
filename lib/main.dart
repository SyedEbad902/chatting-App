import 'package:chatapp/Screens/splash_screen.dart';
import 'package:chatapp/Services/auth_service.dart';
import 'package:chatapp/Services/image_picker_service.dart';
import 'package:chatapp/Services/validation_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // bool isLoggedIn = await whereToGo();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

// Future<bool> whereToGo() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getBool('isLoggedIn') ?? false;
// }

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FirebaseAuthService()),
          ChangeNotifierProvider(create: (_) => ValidationProvider()),
          ChangeNotifierProvider(create: (_) => ImagePickerService()),
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        ));
  }
}
