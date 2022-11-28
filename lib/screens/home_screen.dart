import 'package:app/screens/step_counter_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../components/carousel.dart';
import '../components/reusable_card.dart';
import 'bmi_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static String id = '/home';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Alert(
          context: context,
          type: AlertType.warning,
          title: "Are you sure?",
          desc: "Do you want to exit the app?",
          buttons: [
            DialogButton(
              child: Text(
                "Yes",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                SystemNavigator.pop(animated: true);
                /*_auth.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, LoginScreen.id, (route) => false);*/
              },
              width: 120,
            ),
            DialogButton(
              child: Text(
                "No",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Alert(context: context).dismiss();
              },
              width: 120,
            )
          ],
        ).show();
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.7, 0.9],
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFFDFCFF),
                Color(0xFFebebed),
              ],
            ),
          ),
          child: ListView(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: Row(
                    children: [
                      Text(
                        'Hello',
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 40.0,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Icon(
                        Icons.waving_hand_rounded,
                        size: 40.0,
                        color: Colors.yellow[800],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ReusableCard(
                        child: Column(children: [
                          Icon(Icons.accessibility_new_rounded,
                              size: 50.0, color: Colors.white),
                          Text(
                            'Calculate BMI',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ]),
                        onTap: () {
                          Navigator.pushNamed(context, BMIScreen.id);
                        },
                      ),
                    ),
                    Expanded(
                      child: ReusableCard(
                        child: Column(children: [
                          Icon(Icons.run_circle_outlined,
                              size: 50.0, color: Colors.white),
                          Text(
                            'Steps Counter',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ]),
                        onTap: () {
                          Navigator.pushNamed(context, StepCounterScreen.id);
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text('Health & Fitness Tips',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                Container(
                  child: Carousel(),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
