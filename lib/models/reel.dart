import 'package:video_player/video_player.dart';

class Reel {
  final String videoPath;
  late VideoPlayerController controller;
  bool isVideoInitialized = false;
  final String? title;
  final String? id;
  final String? views;
  final String? likes;
  final String? thumbnailUrl;
  bool isLiked = false;

  Reel(this.videoPath, {this.title, this.views, this.likes, this.id, this.thumbnailUrl}) {
    controller = VideoPlayerController.networkUrl(Uri.parse(videoPath));
  }

  Future<void> initialize() async {
    await controller.initialize();
    controller.setLooping(true);
    isVideoInitialized = true;
    controller.play();
    print('Video playing');
  }

  void dispose() {
    controller.dispose();
  }
}