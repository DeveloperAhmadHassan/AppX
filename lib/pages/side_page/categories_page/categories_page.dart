import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:heroapp/controllers/category_controller.dart';
import 'package:heroapp/models/category.dart';
import 'package:heroapp/pages/side_page/categories_page/reels_by_category_page.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final CategoryController _categoryController = CategoryController(Dio());
  List<Category> _categories = [];
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
      _fetchCategories();
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
      _fetchCategories();
    }
  }

  Future<void> _fetchCategories() async {
    double currentScrollPosition = _scrollController.position.pixels;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _categoryController.fetchCategories(_currentPage);
      setState(() {
        _isLoading = false;
        if (_currentPage == 1) {
          print(result['categories']);
          _categories = result['categories'];
        } else {
          _categories.addAll(result['categories']);
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
      print('Error fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0, bottom: 0.0),
              child: Text(
                "Categories",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
                childAspectRatio: 250 / 280,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return CategoryItem(
                    height: 180,
                    width: 250,
                    category: _categories[index],
                  );
                },
                childCount: _categories.length,
              ),
            ),
          ),
          if (_error)
            SliverToBoxAdapter(
              child: Center(child: Text('Some Error Occurred')),
            ),
          if (!_hasMoreData && _categories.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Center(child: Text('No more categories to load')),
              ),
            ),
          if (_isLoading)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final double height;
  final double width;
  final Category category;

  const CategoryItem({super.key, required this.height, required this.width, required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReelsByCategoryPage(category: "${category.title}"))),
        child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blue,
              image: DecorationImage(
                image: AssetImage(category.thumbnailUrl ?? "https://example.com/your-image-url.jpg"),
                fit: BoxFit.cover,
              ),
            ),

            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "${category.title}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}
