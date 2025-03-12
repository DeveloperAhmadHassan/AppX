import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

import '../../../models/reel.dart';

VideoPlayerController videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(""));

ValueNotifier<Future<void>?> videoFuture = ValueNotifier(null);

ValueNotifier<Reel> reel = ValueNotifier(Reel(""));