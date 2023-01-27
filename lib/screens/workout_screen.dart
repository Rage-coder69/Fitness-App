import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../components/camera.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({
    Key? key,
  }) : super(key: key);

  static String id = '/workout_screen';

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  bool _isBackCamera = false;

  void flipCamera() {
    setState(() {
      _isBackCamera = !_isBackCamera;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text('Workout'),
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
      body: FutureBuilder<List<CameraDescription>>(
        future: availableCameras.call(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Camera(
              camera: snapshot.data![_isBackCamera ? 0 : 1],
              flipCamera: flipCamera,
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF184045),
              ),
            );
          }
        },
      ),
    );
  }
}
