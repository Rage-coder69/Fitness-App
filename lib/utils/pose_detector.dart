import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseDetectorBrain {
  late PoseDetector poseDetector;

  static Future<List<Pose>> getPose(InputImage image) async {
    List<Pose> poses = [];

    PoseDetector poseDetector = PoseDetector(
      options: PoseDetectorOptions(
        mode: PoseDetectionMode.stream,
        model: PoseDetectionModel.base,
      ),
    );

    try {
      poses = await poseDetector.processImage(image);
      for (Pose pose in poses) {
        // to access all landmarks
        pose.landmarks.forEach((_, landmark) {
          final type = landmark.type;
          final x = landmark.x;
          final y = landmark.y;
        });
      }
    } catch (e) {
      print(e);
    }
    print(poses[0].landmarks);
    return poses;
  }
}
