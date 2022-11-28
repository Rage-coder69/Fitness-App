import 'package:app/components/workout_card.dart';
import 'package:app/screens/workout_screen.dart';
import 'package:flutter/material.dart';

class AvailableWorkouts extends StatelessWidget {
  const AvailableWorkouts({Key? key}) : super(key: key);

  static String id = '/available_workouts_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: const Text('Available Workouts'),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            color: Color(0xE8184045),
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xE8184045),
            ),
          ),
        ),
        body: ListView(
          shrinkWrap: false,
          children: [
            WorkoutCard(onTap: () {
              Navigator.pushNamed(context, WorkoutScreen.id);
              /*availableCameras().then((value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WorkoutScreen(cameras: value))));*/
            }),
            WorkoutCard(onTap: () {}),
            WorkoutCard(onTap: () {}),
            WorkoutCard(onTap: () {}),
            WorkoutCard(onTap: () {}),
            WorkoutCard(onTap: () {}),
            WorkoutCard(onTap: () {}),
          ],
        ));
  }
}
