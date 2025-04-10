import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'dart:math' as math;

import '../../controllers/discover_reel_controller.dart';
import '../../models/reel.dart';

import '../../utils/constants.dart';
import '../../utils/extensions/color.dart';
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

class _DiscoverPageState extends State<DiscoverPage> {
  final DiscoverReelController _discoverReelController = DiscoverReelController(Dio());
  List<Reel> _reels = [];
  Map<String, dynamic> _pagination = {};
  bool _isLoading = true;
  int _currentPage = 1;
  bool _hasMoreData = true;
  bool _error = false;
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

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
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading && _hasMoreData) {
      _currentPage = _pagination['nextPage'];
      _fetchReels();
    }

    if (_scrollController.offset > 200 && !_showScrollToTop) {
      setState(() {
        _showScrollToTop = true;
      });
    } else if (_scrollController.offset <= 200 && _showScrollToTop) {
      setState(() {
        _showScrollToTop = false;
      });
    }
  }

  Future<void> _fetchReels() async {
    double currentScrollPosition = _scrollController.position.pixels;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _discoverReelController.fetchReels(_currentPage);
      setState(() {
        _isLoading = false;
        if (_currentPage == 1) {
          _reels = result['reels'];
        } else {
          _reels.addAll(result['reels']);
        }
        _pagination = result['pagination'];
        _hasMoreData = _pagination['nextPage'] <= _pagination['totalPages'];
      });

      if (currentScrollPosition > 0) {
        _scrollController.jumpTo(currentScrollPosition);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      _error = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 110),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, bottom: 10.0),
                    child: Text(
                      "trending",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: itemGrid(),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedSlide(
                offset: !_isLoading && _showScrollToTop ? Offset.zero : Offset(0, 1),
                duration: const Duration(milliseconds: 300),
                child: AnimatedOpacity(
                  opacity: !_isLoading && _showScrollToTop ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 70),
                    child: InkWell(
                      onTap: () {
                        _scrollController.animateTo(
                          0.0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: HexColor.fromHex(AppConstants.primaryColor),
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.8),
                              blurRadius: Theme.of(context).brightness == Brightness.light ? 25 : 6,
                              offset: Offset(0, 7),
                            ),
                          ],
                        ),
                        child: Transform.rotate(
                          angle: -math.pi / 2,
                          child: Icon(
                            Symbols.chevron_right,
                            size: 30,
                            weight: 800,
                            color: HexColor.fromHex(AppConstants.primaryBlack),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget itemGrid() {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    double spacing = screenWidth * 0.02;
    return SizedBox(
      child: GridView.builder(
        itemCount: _reels.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 170 / 280,
        ),
        itemBuilder: (context, index) {
          final reel = _reels[index];
          return Center(
            child: DiscoverItem(
              reel: reel,
              onTap: () async {
                await widget.onReelSelected(reel);
                Future.delayed(const Duration(milliseconds: 200), () {
                  widget.tabController.animateTo(1);
                });
              },
            ),
          );
        },
      ),
    );
  }
}