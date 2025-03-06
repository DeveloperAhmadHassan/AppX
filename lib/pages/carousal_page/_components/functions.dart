import 'package:heroapp/pages/carousal_page/_components/globals.dart';
import 'package:video_player/video_player.dart';

Future<void> play(String url) async {
  if(url.isEmpty) return;
  if(videoPlayerController.value.isInitialized) {
    await videoPlayerController.dispose();
  }
  videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
  return videoPlayerController
    .initialize()
    .then((value) {
      videoPlayerController.setLooping(true);
      videoPlayerController.play();
    });
}