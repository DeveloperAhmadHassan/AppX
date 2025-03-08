import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../controllers/discover_reel_controller.dart';
import '../../models/reel.dart';
import '_components/discover_item.dart';

class DiscoverPage extends StatefulWidget {
  final TabController tabController;
  final Function(Reel) onReelSelected;

  const DiscoverPage({
    super.key,
    required this.tabController,
    required this.onReelSelected,
  });

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> with TickerProviderStateMixin {
  final DiscoverReelController _discoverReelController = DiscoverReelController(Dio());
  List<Reel> _reels = [];
  Map<String, dynamic> _pagination = {};
  bool _isLoading = true;
  int _currentPage = 1;
  bool _hasMoreData = true;
  bool _error = false;
  final ScrollController _scrollController = ScrollController();

  List<AnimationController> _controllers = [];
  List<bool> _animationTriggered = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchReels();
    });
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading && _hasMoreData) {
      _currentPage = _pagination['nextPage'];
      _currentPage = _pagination['nextPage'];
      _fetchReels();
    }
  }

  Future<void> _fetchReels() async {
    double currentScrollPosition = _scrollController.position.pixels;

    if(mounted) {
      setState(() {
        _isLoading = true;
      });

    }
    try {
      final result = await _discoverReelController.fetchReels(_currentPage);
      if(mounted) {
        setState(() {
          _isLoading = false;
          if (_currentPage == 1) {
            _reels = result['reels'];
            _controllers = List.generate(_reels.length, (index) {
              return AnimationController(
                duration: const Duration(milliseconds: 300),
                vsync: this,
              );
            });
            _animationTriggered = List.generate(_reels.length, (index) => false);
          } else {
            _reels.addAll(result['reels']);
            _controllers.addAll(List.generate(result['reels'].length, (index) {
              return AnimationController(
                duration: const Duration(milliseconds: 300),
                vsync: this,
              );
            }));
            _animationTriggered.addAll(List.generate(result['reels'].length, (index) => false));
          }
          _pagination = result['pagination'];
          _hasMoreData = _pagination['nextPage'] <= _pagination['totalPages'];
        });
      }

      if (currentScrollPosition > 0) {
        _scrollController.jumpTo(currentScrollPosition);
      }
    } catch (e) {
      if(mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      _error = true;
      print('Error fetching reels: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 110),
            const Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 0.0),
              child: Text(
                "Trending",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: _controllers.isEmpty ? Container() : itemGrid(),
            ),
            if (_error)
              Center(
                child: const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Center(child: Text('Some Error Occurred')),
                ),
              ),
            if (!_hasMoreData && _reels.isNotEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Center(child: Text('No more reels to load')),
              ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Widget itemGrid() {
    return SizedBox(
      child: GridView.builder(
        itemCount: _reels.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 7),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 18,
          crossAxisSpacing: 0,
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.45),
        ),
        itemBuilder: (context, index) {
          final reel = _reels[index];

          return VisibilityDetector(
            key: Key('item-$index'),
            onVisibilityChanged: (info) {
              if (info.visibleFraction > 0.1 && !_animationTriggered[index]) {
                if(mounted) {
                  setState(() {
                    _animationTriggered[index] = true;
                  });
                }
                _controllers[index].forward();
              }
            },
            child: AnimatedBuilder(
              animation: _controllers[index],
              builder: (context, child) {
                return FadeTransition(
                  opacity: Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _controllers[index],
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: ScaleTransition(
                    scale: Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _controllers[index],
                        curve: Curves.easeInOut,
                      ),
                    ),
                    child: Center(
                      child: DiscoverItem(
                        reel: reel,
                        onTap: () async {
                          await widget.onReelSelected(reel);
                          Future.delayed(const Duration(milliseconds: 200), () {
                            widget.tabController.animateTo(1);
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
