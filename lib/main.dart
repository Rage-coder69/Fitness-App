import 'dart:ui';

import 'package:app/screens/article_screen.dart';
import 'package:app/screens/available_workouts_screen.dart';
import 'package:app/screens/bmi_screen.dart';
import 'package:app/screens/dash_board_screen.dart';
import 'package:app/screens/explore_screen.dart';
import 'package:app/screens/home_screen.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/screens/main_screen.dart';
import 'package:app/screens/register_screen.dart';
import 'package:app/screens/step_counter_screen.dart';
import 'package:app/screens/workout_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*DartPluginRegistrant.ensureInitialized();*/
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      /*home: MainScreen(),*/
      initialRoute: MainScreen.id,
      routes: {
        MainScreen.id: (context) => const MainScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => const RegisterScreen(),
        DashBoardScreen.id: (context) => const DashBoardScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        BMIScreen.id: (context) => const BMIScreen(),
        StepCounterScreen.id: (context) => const StepCounterScreen(),
        ExploreScreen.id: (context) => const ExploreScreen(),
        AvailableWorkouts.id: (context) => const AvailableWorkouts(),
        WorkoutScreen.id: (context) => WorkoutScreen(),
        ArticleScreen.id: (context) => ArticleScreen(),
      },
    );
  }
}
