import 'package:flutter/cupertino.dart';
import 'package:heroapp/models/reel.dart';
import 'package:video_player/video_player.dart';

VideoPlayerController videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(""));

ValueNotifier<Future<void>?> videoFuture = ValueNotifier(null);

ValueNotifier<Reel> reel = ValueNotifier(Reel(""));