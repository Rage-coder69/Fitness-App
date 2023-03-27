import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PosePainter extends CustomPainter {
  final Pose pose;
  final Size imageSize;
  final Size screenSize;

  PosePainter(this.pose, this.imageSize, this.screenSize);

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / imageSize.width;
    final scaleY = size.height / imageSize.height;
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 10;
    // for (final landmark in pose.landmarks) {
    //   final x = landmark.x * scaleX;
    //   final y = landmark.y * scaleY;
    //   canvas.drawCircle(Offset(x, y), 5, paint);
    // }
    pose.landmarks.forEach((_, landmark) {
      final x = landmark.x * scaleX;
      final y = landmark.y * scaleY;
      canvas.drawCircle(Offset(x, y), 5, paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
