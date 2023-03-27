import 'dart:async';

import 'package:app/components/round_icon_button.dart';
import 'package:app/utils/pose_detector.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../utils/pose_painter.dart';

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
  StreamController<List<Pose>> _poseStreamController =
      StreamController.broadcast();

  List<Pose> poses = [];
  bool _isDetecting = false;

  late PoseDetector poseDetector;

  /*Uint8List concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    planes.forEach((Plane plane) => allBytes.putUint8List(plane.bytes));
    return allBytes.done().buffer.asUint8List();
  }*/

  InputImageRotation _rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        throw Exception('Unsupported rotation value: $rotation');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
    poseDetector = PoseDetector(
      options: PoseDetectorOptions(
        mode: PoseDetectionMode.stream,
        model: PoseDetectionModel.base,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    poseDetector.close();
    _poseStreamController.close();
    super.dispose();
  }

  Future<void> _onImageStream(CameraImage image) async {
    final rotation = _controller.value.deviceOrientation.index;
    final inputImage = InputImage.fromBytes(
      bytes: image.planes[0].bytes,
      inputImageData: InputImageData(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        imageRotation: _rotationIntToImageRotation(rotation),
        inputImageFormat: InputImageFormatValue.fromRawValue(image.format.raw)!,
        planeData: image.planes.map(
          (Plane plane) {
            return InputImagePlaneMetadata(
              bytesPerRow: plane.bytesPerRow,
              height: plane.height,
              width: plane.width,
            );
          },
        ).toList(),
      ),
    );

    final poses = await poseDetector.processImage(inputImage);

    _poseStreamController.add(poses);
  }

  Widget _buildCameraPreview() {
    return Positioned.fill(
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: CameraPreview(_controller),
      ),
    );
  }

  Widget _buildPoseLandmarks() {
    return Positioned.fill(
      child: StreamBuilder<List<Pose>>(
        stream: _poseStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final poses = snapshot.data!;
            for (var pose in poses) {
              return CustomPaint(
                painter: PosePainter(
                  pose,
                  Size(_controller.value.previewSize!.height.toDouble(),
                      _controller.value.previewSize!.width.toDouble()),
                  MediaQuery.of(context).size,
                ),
              );
            }
            return SizedBox.shrink();
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
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
            child: Stack(
              children: [
                _buildCameraPreview(),
                _buildPoseLandmarks(),
              ],
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
                    setState(() {
                      _isDetecting = true;
                      // _poseStreamController.add(_controller);
                      _controller.startImageStream(_onImageStream);
                    });
                  },
                ),
                RoundIconButton(
                  onTap: () {
                    setState(() {
                      _isDetecting = false;
                      _poseStreamController.close();
                      _controller.stopImageStream();
                    });
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

/*
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
*/
//https://www.instagram.com/reel/CoreJO8IdmP/?utm_source=ig_web_copy_link

/*StreamBuilder(
                    stream: controllerStream.stream,
                    builder: (context, snapshot) {
                      if (!_controller.value.isInitialized) {
                        return Container();
                      }
                      final size = MediaQuery.of(context).size;
                      final deviceRatio = size.width / size.height;
                      return FutureBuilder(
                        future: _detectPoses(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          }
                          final poses = snapshot.data;
                          return Stack(
                            children: [
                              Transform.scale(
                                scale:
                                    _controller.value.aspectRatio / deviceRatio,
                                child: Center(
                                  child: AspectRatio(
                                    aspectRatio: _controller.value.aspectRatio,
                                    child: CameraPreview(_controller),
                                  ),
                                ),
                              ),
                              for (final pose in poses!)
                                CustomPaint(
                                  painter: PosePainter(
                                    pose,
                                    _controller.value.previewSize!,
                                    size,
                                  ),
                                ),
                            ],
                          );
                        },
                      );
                    },
                  )
                : FutureBuilder<void>(
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
                  ),*/
