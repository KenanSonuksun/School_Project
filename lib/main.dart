import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolproject/providers/classesProvider.dart';
import 'package:schoolproject/providers/profileProvider.dart';
import 'package:schoolproject/providers/validationLogin.dart';
import 'package:schoolproject/providers/validationSignup.dart';
import 'package:schoolproject/screens/splashPage.dart';
import 'package:schoolproject/screens/teacher/HomePage/teacherHomePage.dart';
import 'package:schoolproject/service/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => LoginValidation()),
      ChangeNotifierProvider(create: (context) => SignupValidation()),
      ChangeNotifierProvider(create: (context) => FirebaseService()),
      ChangeNotifierProvider(create: (context) => ClassesProvider()),
      ChangeNotifierProvider(create: (context) => ProfileProvider()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.white,
        ),
        fontFamily: "Muli",
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: email != null ? TeacherHomePage() : SplashPage(),
    ),
  ));
}
