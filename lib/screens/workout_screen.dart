import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';


import '../components/round_icon_button.dart';
import '../utils/signaling.dart';

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

  CameraController? _controller;

  // signaling
  Signaling signaling = Signaling();
  MediaStream? _localStream;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;


  void flipCamera() {
    _isBackCamera = !_isBackCamera;
    getCamera();
  }

  Future<void> getCamera() async {
    dynamic cameras = await availableCameras.call();
    dynamic camera = cameras[_isBackCamera ?  0 : 1 ];
    setState(() {
      _controller = CameraController(camera, ResolutionPreset.ultraHigh);
    });
  }

  final Map<String, dynamic> mediaConstraints = {
    "audio": true,
    "video": {
      "mandatory": {
        "minWidth": '740', // Provide your own width, height and frame rate here
        "minHeight": '580',
        "minFrameRate": '60',
      },
      "facingMode": "user",
      "optional": [],
    }
  };


  void initState () {
    super.initState();
    _localRenderer.initialize();
    mediaDevices.getUserMedia(mediaConstraints).then((stream){
      _localStream = stream;
      _localRenderer.srcObject = _localStream;
    });
    _remoteRenderer.initialize();
    signaling.onAddRemoteStream = (stream) {
      _remoteRenderer.srcObject = stream;
    };
    setState(() {});

    //getCamera();
  }

  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller?.dispose();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
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
      body: Container(
        padding: const EdgeInsets.all(0.0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 7,
              child: RTCVideoView(_localRenderer,
                mirror: true,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
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
                          flipCamera();
                        },
                        icon: Icons.flip_camera_ios_rounded,
                      ),
                      RoundIconButton(
                        icon: Icons.play_arrow_rounded,
                        onTap: () {
                        },
                      ),
                      RoundIconButton(
                        onTap: () {
                        },
                        icon: Icons.pause_circle_filled_rounded,
                      ),
                    ],
                  ),
                ),),
          ],
        ),
      ),
    );
  }
}

/*FutureBuilder<void>(
                future: _controller?.initialize(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the Future is complete, display the preview.
                    return CameraPreview(_controller!);
                  } else {
                    // Otherwise, display a loading indicator.
                    return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF184045),
                        ));
                  }
                },
              ),*/
