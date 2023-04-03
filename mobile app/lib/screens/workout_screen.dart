import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;

import '../components/round_icon_button.dart';

typedef void StreamStateCallback(MediaStream stream);

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({
    Key? key,
  }) : super(key: key);

  static String id = '/workout_screen';

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  final _localRenderer = RTCVideoRenderer();

  void initRenderers() async {
    await _localRenderer.initialize();
  }

  void _onTrack(RTCTrackEvent event) {
    print("TRACK EVENT: ${event.streams.map((e) => e.id)}, ${event.track.id}");
    if (event.track.kind == "video") {
      print("HERE");
      _localRenderer.initialize();
      setState(() {
        _localRenderer.srcObject = event.streams[0];
      });
    }
  }

  Future<bool> _waitForGatheringComplete(_) async {
    print("WAITING FOR GATHERING COMPLETE");
    if (_peerConnection!.iceGatheringState ==
        RTCIceGatheringState.RTCIceGatheringStateComplete) {
      return true;
    } else {
      await Future.delayed(Duration(seconds: 1));
      return await _waitForGatheringComplete(_);
    }
  }

  Future<void> _negotiateRemoteConnection() async {
    return _peerConnection!
        .createOffer()
        .then((offer) {
          return _peerConnection!.setLocalDescription(offer);
        })
        .then(_waitForGatheringComplete)
        .then((_) async {
          print("after waiting");
          var des = await _peerConnection!.getLocalDescription();
          var headers = {
            'Content-type': 'application/json',
          };

          var request = http.Request(
            'POST',
            Uri.parse('http://192.168.1.2:5000/offer'),
          );

          request.body = jsonEncode(
              {"sdp": des!.sdp, "type": des.type, "exercise": "pushUp"});

          request.headers.addAll(headers);

          http.StreamedResponse response = await request.send();
          print(response.statusCode);
          if (response.statusCode == 200) {
            String data = await response.stream.bytesToString();
            var dataMap = jsonDecode(data);
            print(dataMap["type"]);
            await _peerConnection!.setRemoteDescription(
              RTCSessionDescription(
                dataMap["sdp"],
                dataMap["type"],
              ),
            );
          } else {
            print(response.reasonPhrase);
          }
        });
  }

  Future<void> _makeCall() async {
    var configuration = <String, dynamic>{
      'iceServers': [],
      'sdpSemantics': 'unified-plan',
    };

    //* Create Peer Connection
    if (_peerConnection != null) return;
    _peerConnection = await createPeerConnection(configuration);

    _peerConnection!.onTrack = _onTrack;

    final Map<String, dynamic> mediaConstraints = {
      'audio': false,
      'video': {
        'mandatory': {
          'minWidth': // parse to int here
              MediaQuery.of(context).size.width.toInt().toString(),
          'minHeight': MediaQuery.of(context).size.height.toInt().toString(),
          'minFrameRate': '30',
          'maxFrameRate': '60'
        },
        'facingMode': 'user',
        'optional': [],
      }
    };

    try {
      var stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);

      _localStream = stream;

      stream.getTracks().forEach((element) {
        _peerConnection!.addTrack(element, stream);
      });

      await _negotiateRemoteConnection();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    initRenderers();
  }

  @override
  void dispose() {
    super.dispose();
    _localRenderer.dispose();
  }

  Future<void> _stopCall() async {
    try {
      await _peerConnection?.close();
      setState(() {
        _peerConnection = null;
        _localRenderer.srcObject = null;
      });
    } catch (e) {
      print(e.toString());
    }
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
              child: _localRenderer.srcObject != null
                  ? RTCVideoView(_localRenderer,
                      mirror: true,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover)
                  : Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF184045),
                      ),
                      child: const Center(
                        child: Text(
                          'No Video',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
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
                      icon: Icons.play_arrow_rounded,
                      onTap: _makeCall,
                    ),
                    RoundIconButton(
                      onTap: _stopCall,
                      icon: Icons.pause_circle_filled_rounded,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
