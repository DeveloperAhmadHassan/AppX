import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'reel_meta_data.dart';
import 'chunk_indicators.dart';
import '../../../controllers/home_reel_controller.dart';
import '../../../models/reel.dart';
import '../../../utils/extensions/string.dart';

class HomeReelItem extends StatefulWidget {
  const HomeReelItem({super.key, required this.reel, required this.videoPlayerController});
  final Reel reel;
  final VideoPlayerController videoPlayerController;

  @override
  State<HomeReelItem> createState() => _HomeReelItemState();
}

class _HomeReelItemState extends State<HomeReelItem> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;
  bool _isVideoPlaying = false;
  bool _isControllerDisposed = false;
  late HomeReelController _homeReelController;

  double _currentPosition = 0.0;
  int _currentTimestamp = 0;

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction <= 0.5 && _isVideoPlaying) {
      if (!_isControllerDisposed && _controller.value.isInitialized) {
        _controller.pause();
        if (mounted) {
          setState(() {
            _isVideoPlaying = false;
          });
        }
      }
    } else if (info.visibleFraction > 0.5 && !_isVideoPlaying) {
      if (!_isControllerDisposed && _controller.value.isInitialized) {
        _controller.play();
        if (mounted) {
          setState(() {
            _isVideoPlaying = true;
          });
        }
      }
    }
  }

  void _seekToClosestTimestamp(bool isForward) {
    int closestTimestamp = _currentTimestamp;
    List<Duration> timestampsInDurations = widget.reel.timestamps!
      .map((e) => e.toDuration())
      .toList();

    if (isForward) {
      for (var timestamp in timestampsInDurations) {
        if (timestamp.inSeconds > _currentTimestamp) {
          closestTimestamp = timestamp.inSeconds;
          break;
        }
      }
    } else {
      for (var timestamp in timestampsInDurations.reversed) {
        if (timestamp.inSeconds < _currentTimestamp) {
          closestTimestamp = timestamp.inSeconds;
          break;
        }
      }
    }

    setState(() {
      _currentTimestamp = closestTimestamp;
      _controller.seekTo(Duration(seconds: closestTimestamp));
    });
  }

  void _updateProgress() {
    if (_controller.value.isInitialized) {
      if (mounted) {
        setState(() {
          _currentPosition = _controller.value.position.inSeconds.toDouble();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _homeReelController = HomeReelController(Dio());

    // setState(() {
    //   widget.videoPlayerController.setLooping(true);
    //   widget.videoPlayerController.play();
    // });

    print(widget.reel.reelUrl);

    _controller = VideoPlayerController.asset(widget.reel.reelUrl)
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _isVideoInitialized = true);
        }
        _controller
          ..setLooping(true)
          ..play();
        _isVideoPlaying = true;

        /// Updates the progress indicator every [50ms] to reflect video playback.
        /// This interval balances smooth UI updates with performance considerations.
        Timer.periodic(Duration(milliseconds: 50), (timer) {
          if (_controller.value.isInitialized) {
            _updateProgress();
          }
        });

        /// Resets progress tracking when video completes.
        /// Uses seconds comparison (instead of milliseconds) to avoid precision errors
        /// that could occur if checking exact duration matches.
        _controller.addListener(() {
          final position = _controller.value.position;
          final duration = _controller.value.duration;

          if (position.inSeconds == duration.inSeconds) {
            setState(() {
              _currentPosition = 0.0;
              _currentTimestamp = 0;
            });
          }
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    if (mounted) {
      _isControllerDisposed = true;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 90),
            /// Video Chunk Indicators
            // SizedBox(height: 10),
            /// Video Player
            videoItem(context),
            /// Video Meta Data
            ReelMetaData(reel: widget.reel, homeReelController: _homeReelController),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Stack videoItem(BuildContext context) {
    return Stack(
      children: [
        VisibilityDetector(
          onVisibilityChanged: (info) {
            if(info.visibleFraction <= 0.5) {
              _controller.pause();
            } else {
              _controller.play();
            }
          },
          key: Key("reel-${widget.reel.id}"),
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height - 200,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: _isVideoInitialized ? InkWell(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: VideoPlayer(_controller),
                ),
              ) : ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  widget.reel.thumbnailUrl ?? "",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        if(_isVideoInitialized)
          Positioned(
            child: Container(
              padding: EdgeInsets.only(top: 10.0),
              height: 30,
              // color: Colors.red,
              child: ChunkIndicators(reel: widget.reel, currentPosition: _currentPosition),
            ),
          ),
        Positioned(
          right: 0,
          left: MediaQuery.of(context).size.width / 2,
          top: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.only(right: 10.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                _seekToClosestTimestamp(true);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: MediaQuery.of(context).size.width / 2,
          left: 0,
          top: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                _seekToClosestTimestamp(false);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}





