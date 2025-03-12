import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'category_reel_item.dart';
import '../../../controllers/category_controller.dart';
import '../../../models/reel.dart';

class ReelsByCategoryPage extends StatefulWidget {
  final String category;
  const ReelsByCategoryPage({
    super.key,
    required this.category,
  });

  @override
  State<ReelsByCategoryPage> createState() => _ReelsByCategoryPageState();
}

class _ReelsByCategoryPageState extends State<ReelsByCategoryPage> {
  final CategoryController _categoryController = CategoryController(Dio());
  List<Reel> _reels = [];
  Map<String, dynamic> _pagination = {};
  bool _isLoading = true;
  int _currentPage = 1;
  bool _hasMoreData = true;
  bool _error = false;
  final ScrollController _scrollController = ScrollController();

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
  }

  Future<void> _fetchReels() async {
    double currentScrollPosition = _scrollController.position.pixels;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _categoryController.fetchReelsByCategory(_currentPage, widget.category);
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
      setState(() {
        _isLoading = false;
      });
      _error = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0.0),
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
    );
  }

  Widget itemGrid() {
    return SizedBox(
      child: GridView.builder(
        itemCount: _reels.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 7, bottom: 15.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 18,
          crossAxisSpacing: 0,
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.45),
        ),
        itemBuilder: (context, index) {
          final reel = _reels[index];
          return Center(
            child: CategoryReelItem(
              reel: reel,
            ),
          );
        },
      ),
    );
  }
}