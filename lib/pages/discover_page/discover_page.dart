import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../controllers/discover_reel_controller.dart';
import '../../models/reel.dart';
import '_components/discover_item.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

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
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchReels();
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
  }

  Future<void> _fetchReels() async {
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
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching reels: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 110),
            const Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 0.0),
              child: Text(
                "Trending",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: _isLoading && _reels.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : itemGrid(),
            ),
            if (_isLoading && _reels.isNotEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (!_hasMoreData && _reels.isNotEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Center(child: Text('No more reels to load', style: TextStyle(color: Colors.white))),
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
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 1.45),
        ),
        itemBuilder: (context, index) {
          final reel = _reels[index];
          return Center(
            child: DiscoverItem(
              reel: reel,
            ),
          );
        },
      ),
    );
  }
}
