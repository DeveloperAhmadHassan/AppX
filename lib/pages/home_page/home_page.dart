import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:heroapp/pages/home_page/_components/home_reel_item.dart';
import 'package:heroapp/utils/assets.dart';
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

  bool _showBackdrop = true;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    reels = [];
    if (widget.reel != null) {
      reels.insert(0, widget.reel!);
    } else if (widget.reel == null) {
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
        });
      }
    }
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
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          _error = true;
        });
      }
      print('Error fetching reels: $e');
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

  @override
  void dispose() {
    _viewTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onTouch() {
    if (_showBackdrop) {
      setState(() {
        _showBackdrop = false;
      });
      setState(() {
        _pageController.animateToPage(1, duration: Duration(seconds: 1), curve: Curves.easeInOut);
      });
    }
  }

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
            onPageChanged: (index) {
              if (index < reels.length) {
                final reel = reels[index];
                _currentReelId = reel.id;
                _startViewTimer(reel);
              }
            },
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
                return HomeReelItem(reel: reels[index]);
              }
            },
          ),
          _showBackdrop ? GestureDetector(
            onPanUpdate: (details) {
              _onTouch();
            },
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.4),
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
