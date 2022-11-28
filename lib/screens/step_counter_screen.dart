import 'package:flutter/material.dart';

class StepCounterScreen extends StatelessWidget {
  const StepCounterScreen({Key? key}) : super(key: key);

  static String id = '/step_counter_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text('Step Counter'),
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
      body: Container(
        child: const Center(
          child: Text('Step Counter Screen'),
        ),
      ),
    );
  }
}
