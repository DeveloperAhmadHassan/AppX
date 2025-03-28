import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart'; // Import video player

import '_components/home_reel_item.dart';
import '../../utils/assets.dart';
import '../../controllers/home_reel_controller.dart';
import '../../models/reel.dart';

class HomePage extends StatefulWidget {
  final Reel? reel;
  const HomePage({super.key, this.reel});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Reel> reels;
  bool isLoading = false;
  int currentPage = 1;
  int nextPage = 1;
  final HomeReelController apiController = HomeReelController(Dio());
  final Set<String> viewedReels = {};
  Timer? _viewTimer;
  String? _currentReelId;
  bool _error = false;

  bool _showBackdrop = false;
  late PageController _pageController;
  
  int controllerPointer = 0;

  // List to hold VideoPlayerControllers
  List<VideoPlayerController> videoControllers = [];

  @override
  void initState() {
    super.initState();
    _loadShowBackdrop();
    reels = [];
    if (widget.reel != null) {
      reels.insert(0, widget.reel!);
    } else {
      if (kDebugMode) {
        print("Reel is null");
      }
    }
    fetchReels(currentPage);

    _pageController = PageController(initialPage: 0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (reels.isNotEmpty) {
        _currentReelId = reels[0].id;
        _startViewTimer(reels[0]);
        _initializeVideoControllers(); // Initialize controllers on start
      }
    });
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.reel != oldWidget.reel) {
      if (mounted) {
        setState(() {
          reels.clear();
          if (widget.reel != null) {
            reels.insert(0, widget.reel!);
          }
          fetchReels(currentPage);
          _initializeVideoControllers(); // Reinitialize video controllers
        });
      }
    }
  }

  @override
  void dispose() {
    _viewTimer?.cancel();
    _pageController.dispose();
    // Dispose of all video controllers
    for (var controller in videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadShowBackdrop() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _showBackdrop = prefs.getBool('showBackdrop') ?? true;
    });
  }

  Future<void> _saveShowBackdrop() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('showBackdrop', _showBackdrop);
  }

  Future<void> fetchReels(int page) async {
    if (isLoading) return;
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      var result = await apiController.fetchReels(page);
      List<Reel> fetchedReels = result['reels'];
      Map<String, dynamic> pagination = result['pagination'];

      if (mounted) {
        setState(() {
          reels.addAll(fetchedReels);
          currentPage = pagination['page'];
          nextPage = pagination['nextPage'];
          isLoading = false;
        });
        // Initialize video controllers after reels are fetched
        _initializeVideoControllers();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          _error = true;
        });
      }
    }
  }

  void _startViewTimer(Reel reel) {
    _viewTimer?.cancel();

    _viewTimer = Timer(Duration(seconds: 3), () async {
      if (_currentReelId == reel.id) {
        viewedReels.add(reel.id ?? "49");
        reel.dateWatched ??= DateTime.now();
        await apiController.incrementViews(reel);
      }
    });
  }

  void _onTouch() {
    if (_showBackdrop) {
      setState(() {
        _showBackdrop = false;
      });
      _saveShowBackdrop();
      setState(() {
        _pageController.animateToPage(1, duration: Duration(seconds: 1), curve: Curves.easeInOut);
      });
    }
  }

  // Initialize video controllers
  void _initializeVideoControllers() {
    // Only keep up to 4 controllers in memory
    for (int i = 0; i < 4; i++) {
      if (reels.length > i) {
        final controller = VideoPlayerController. networkUrl(Uri.parse(reels[i].reelUrl))
          ..initialize().then((_) {
            if (mounted) {
              setState(() {});
            }
          });
        videoControllers.add(controller);
      }
    }
  }

  // Handle page change for the video controllers
  void _onPageChangedDownwards(int index) {
    if (index < reels.length) {
      final reel = reels[index];
      _currentReelId = reel.id;
      _startViewTimer(reel);

      setState(() {
        controllerPointer = index % 4;
      });
      print('Index: $index ----- Pointer: $controllerPointer');

      if(controllerPointer == 0) {
        if(index >=4 ){
          print("Video Controller ${(index - 2) % 4} disposed ----- Reel Id: ${reels[index - 2].id}");
          print("Video Controller ${(index - 1) % 4} paused ----- Reel Id: ${reels[index - 1].id}");
        }
        print("Video Controller $controllerPointer played ----- Reel Id: ${reels[index].id}");
        print("Video Controller ${(controllerPointer + 1)} initialised ----- Reel Id: ${reels[index + 1].id}");
      }

      if(controllerPointer == 1) {
        if(index >=4 ){
          print("Video Controller ${(index - 2) % 4} disposed ----- Reel Id: ${reels[index - 2].id}");
        }
        print("Video Controller ${controllerPointer - 1} paused ----- Reel Id: ${reels[index - 1].id}");
        print("Video Controller $controllerPointer played ----- Reel Id: ${reels[index].id}");
        print("Video Controller ${(controllerPointer + 1)} initialised ----- Reel Id: ${reels[index + 1].id}");
      }

      if(controllerPointer == 2) {
        print("Video Controller ${controllerPointer - 2} disposed ----- Reel Id: ${reels[index - 2].id}");
        print("Video Controller ${controllerPointer - 1} paused ----- Reel Id: ${reels[index - 1].id}");
        print("Video Controller $controllerPointer played ----- Reel Id: ${reels[index].id}");
        print("Video Controller ${controllerPointer + 1} initialised ----- Reel Id: ${reels[index + 1].id}");
      }

      if(controllerPointer == 3) {
        print("Video Controller ${controllerPointer - 2} disposed ----- Reel Id: ${reels[index - 2].id}");
        print("Video Controller ${controllerPointer - 1} paused ----- Reel Id: ${reels[index - 1].id}");
        print("Video Controller $controllerPointer played ----- Reel Id: ${reels[index].id}");
        print("Video Controller ${(controllerPointer + 1) % 4} initialised ----- Reel Id: ${reels[index + 1].id}");
      }

      // Play the current video
      if (videoControllers.isNotEmpty && index < videoControllers.length) {
        videoControllers[index].play();
      }

      // Preload the next video (video controller for the next URL)
      if (index + 1 < reels.length && videoControllers.length > index) {
        _initializeNextVideoController(index + 1);
      }

      // Dispose of the controller that is two indices behind
      if (index - 2 >= 0) {
        videoControllers[index - 2].dispose();
        videoControllers.removeAt(index - 2);
      }
    }
  }

  void _onPageChangedUpwards(int index) {
    if (index < reels.length) {
      final reel = reels[index];
      _currentReelId = reel.id;
      _startViewTimer(reel);

      setState(() {
        controllerPointer = index % 4;
      });
      print('Index: $index ----- Pointer: $controllerPointer');

      if(controllerPointer == 0) {
        if(index >= 4) {
          print("Video Controller ${(index - 1) % 4} initialised ----- Reel Id: ${reels[index - 1].id}");
        }
        print("Video Controller $controllerPointer played ----- Reel Id: ${reels[index].id}");
        print("Video Controller ${controllerPointer + 1} paused ----- Reel Id: ${reels[index + 1].id}");
        if(index <= 4) {
          print("Video Controller ${(index - 2) % 4} disposed ----- Reel Id: ${reels[index + 2].id}");
        }
      }

      if(controllerPointer == 1) {
        print("Video Controller ${controllerPointer - 1} initialised ----- Reel Id: ${reels[index - 1].id}");
        print("Video Controller $controllerPointer played ----- Reel Id: ${reels[index].id}");
        print("Video Controller ${controllerPointer + 1} paused ----- Reel Id: ${reels[index + 1].id}");
        print("Video Controller ${controllerPointer + 2} disposed ----- Reel Id: ${reels[index + 2].id}");
      }

      if(controllerPointer == 2) {
        print("Video Controller ${controllerPointer - 1} initialised ----- Reel Id: ${reels[index - 1].id}");
        print("Video Controller $controllerPointer played ----- Reel Id: ${reels[index].id}");
        print("Video Controller ${controllerPointer + 1} paused ----- Reel Id: ${reels[index + 1].id}");
        if(index <= 4) {
          print("Video Controller ${(index + 2) % 4} disposed ----- Reel Id: ${reels[index + 2].id}");
        }
      }

      if(controllerPointer == 3) {
        print("Video Controller ${controllerPointer - 1} initialised ----- Reel Id: ${reels[index - 1].id}");
        print("Video Controller $controllerPointer played ----- Reel Id: ${reels[index].id}");
        if(index <= 4) {
          print("Video Controller ${(index + 1) % 4} paused ----- Reel Id: ${reels[index + 1].id}");
          print("Video Controller ${(index + 2) % 4} disposed ----- Reel Id: ${reels[index + 2].id}");
        }
      }
    }
  }

  // Initialize the next video controller
  void _initializeNextVideoController(int nextIndex) {
    if (nextIndex < reels.length) {
      final controller = VideoPlayerController.networkUrl(Uri.parse(reels[nextIndex].reelUrl))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
          }
        });
      videoControllers.add(controller);
    }
  }

  int _previousIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemCount: reels.length + 1,
            controller: _pageController,
            scrollDirection: Axis.vertical,
            physics: _showBackdrop ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
            onPageChanged: (int index) {
              // Detect the direction of the scroll (up or down)
              if (index > _previousIndex) {
                print("Scrolled down");
                _onPageChangedDownwards(index);
              } else if (index < _previousIndex) {
                print("Scrolled up");
                _onPageChangedUpwards(index);
              }

              // Update the previous index to the current index
              _previousIndex = index;

              // Call your existing page change handler
              // _onPageChangedDownwards(index);
            }, // Handle page changes here
            itemBuilder: (context, index) {
              if (index == reels.length) {
                if (isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (_error) {
                  return Center(
                    child: const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Center(child: Text('Some Error Occurred')),
                    ),
                  );
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    fetchReels(nextPage);
                  });
                  return Container();
                }
              } else {
                if (index >= videoControllers.length) {
                  _initializeVideoControllers();
                }

                print(videoControllers.length);
                videoControllers[index]
                  ..setLooping(true)
                  ..play();
                return HomeReelItem(
                  reel: reels[index],
                  videoPlayerController: index < videoControllers.length
                      ? videoControllers[index]
                      : VideoPlayerController.networkUrl(Uri.parse(reels[index].reelUrl)),
                );
              }
            },
          ),
          _showBackdrop && reels.isNotEmpty ? GestureDetector(
            onPanUpdate: (details) {
              _onTouch();
            },
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(Assets.profileTutorialScreen),
                  ),
                ),
              ),
            ),
          ) : Container(),
        ],
      ),
    );
  }
}
