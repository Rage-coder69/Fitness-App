import 'package:app/components/round_icon_button.dart';
import 'package:app/utils/pose_detector.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class Camera extends StatefulWidget {
  const Camera({Key? key, required this.camera, required this.flipCamera})
      : super(key: key);

  final camera;
  final flipCamera;

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  List<Pose> poses = [];

  Uint8List concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    planes.forEach((Plane plane) => allBytes.putUint8List(plane.bytes));
    return allBytes.done().buffer.asUint8List();
  }

  @override
  void initState() {
    super.initState();
    /*Alert(
      context: context,
      title: 'Select Camera',
      desc:
          'Select the camera you want to use, it can be either the front or the back camera. Press the camera icon below to switch between the two.',
      buttons: [
        DialogButton(
          child: const Text(
            'Ok',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {},
          color: const Color(0xFF184045),
        ),
      ],
    ).show();*/
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.ultraHigh,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 7,
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview.
                  return CameraPreview(_controller);
                } else {
                  // Otherwise, display a loading indicator.
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Color(0xFF184045),
                  ));
                }
              },
            ),
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF184045),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RoundIconButton(
                  onTap: () {
                    widget.flipCamera();
                  },
                  icon: Icons.flip_camera_ios_rounded,
                ),
                RoundIconButton(
                  icon: Icons.play_arrow_rounded,
                  onTap: () async {
                    try {
                      // Ensure that the camera is initialized.
                      await _initializeControllerFuture;

                      // Attempt to take a picture and then get the location
                      // where the image file is saved.
                      await _controller.startImageStream((image) => {
                            setState(() async {
                              poses = await PoseDetectorBrain.getPose(
                                InputImage.fromBytes(
                                  bytes: concatenatePlanes(image.planes),
                                  inputImageData: InputImageData(
                                    size: Size(image.width.toDouble(),
                                        image.height.toDouble()),
                                    imageRotation:
                                        InputImageRotation.rotation0deg,
                                    inputImageFormat: InputImageFormat.nv21,
                                    planeData: image.planes.map((Plane plane) {
                                      return InputImagePlaneMetadata(
                                        bytesPerRow: plane.bytesPerRow,
                                        height: plane.height,
                                        width: plane.width,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            })
                          });
                    } catch (e) {
                      // If an error occurs, log the error to the console.
                      print(e);
                    }
                  },
                ),
                RoundIconButton(
                  onTap: () {
                    try {
                      _controller.stopImageStream();
                    } catch (e) {
                      // If an error occurs, log the error to the console.
                      print(e);
                    }
                  },
                  icon: Icons.pause_circle_filled_rounded,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
