// @dart=2.9
import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:help_247/Models/preference.dart';
import 'package:help_247/Screens/login_Screen.dart';
import 'package:help_247/Screens/main_screen.dart';
import 'package:help_247/onboarding/welcome_screen.dart';
import 'package:help_247/units/colors.dart';
import 'package:help_247/units/const.dart';
import 'package:help_247/units/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  bool isFirstTimeOpen = false;

  MyAppState() {
    MySharedPreferences.instance
        .getBooleanValue("firstTimeOpen")
        .then((value) => setState(() {
              isFirstTimeOpen = value;
            }));
  }

  StreamSubscription<User> loggedInUser;

  void initState() {
    super.initState();

    loggedInUser = FirebaseAuth.instance.authStateChanges().listen((user) {});
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: alphaColor,
        accentColor: gammaColor,
      ),
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        duration: 800,
        splash: Column(
          children: [
            Center(
              child: ClipRect(
                child: Image.asset('Images/splh.png', height: 60, width: 60),
              ),
            ),
            Text(
              appName,
              style: splashScreenText,
            ),
          ],
        ),
        backgroundColor: gammaColor,
        nextScreen: FirebaseAuth.instance.currentUser != null
            ? MainScreen()
            : isFirstTimeOpen
                ? LoginScreen()
                : OnBoardWelcomeScreen(),
      ),
      builder: EasyLoading.init(),
    );
  }
}
