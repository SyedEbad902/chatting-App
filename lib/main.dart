import 'package:chatapp/Screens/splash_screen.dart';
import 'package:chatapp/Services/auth_service.dart';
import 'package:chatapp/Services/calling_service.dart';
import 'package:chatapp/Services/database_service.dart';
import 'package:chatapp/Services/image_picker_service.dart';
import 'package:chatapp/Services/toast_service.dart';
import 'package:chatapp/Services/validation_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp();
  final navigatorKey = GlobalKey<NavigatorState>();

  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  // call the useSystemCallingUI
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );
    runApp(MyApp(navigatorKey: navigatorKey));
  });
}

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());
  getIt.registerLazySingleton<DatabaseServiceProvider>(
      () => DatabaseServiceProvider());
  getIt.registerLazySingleton<ImagePickerService>(() => ImagePickerService());
  getIt.registerLazySingleton<ToastService>(() => ToastService());
}


class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({
    required this.navigatorKey,
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FirebaseAuthService()),
          ChangeNotifierProvider(create: (_) => ValidationProvider()),
          ChangeNotifierProvider(create: (_) => ImagePickerService()),
          ChangeNotifierProvider(create: (_) => DatabaseServiceProvider()),
          ChangeNotifierProvider(create: (_) => CallingService()),
          ChangeNotifierProvider(create: (_) => ToastService()),
        ],
        child: MaterialApp(
          navigatorKey: widget.navigatorKey,
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        ));
  }
}
