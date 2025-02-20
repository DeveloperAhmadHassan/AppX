import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:heroapp/pages/home_page/_components/home_reel_item.dart';
import '../../controllers/home_reel_controller.dart';
import '../../models/reel.dart';

class HomePage extends StatefulWidget {
  Reel? reel;
  HomePage({super.key, this.reel});

  @override
  _HomePageState createState() => _HomePageState();
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

  @override
  void initState() {
    super.initState();
    reels = [];
    if(widget.reel != null) {
      reels.insert(0, widget.reel!);
    }
    fetchReels(currentPage);
  }

  Future<void> fetchReels(int page) async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiController.fetchReels(page);
      List<Reel> fetchedReels = result['reels'];
      Map<String, dynamic> pagination = result['pagination'];

      setState(() {
        reels.addAll(fetchedReels);
        currentPage = pagination['page'];
        nextPage = pagination['nextPage'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching reels: $e');
    }
  }

  void _startViewTimer(String reelId) {
    _viewTimer?.cancel();

    _viewTimer = Timer(Duration(seconds: 3), () {
      if (_currentReelId == reelId) {
        print('Views incremented');
        viewedReels.add(reelId);
      }
    });
  }

  @override
  void dispose() {
    _viewTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: reels.length + 1,
        controller: PageController(initialPage: 0),
        scrollDirection: Axis.vertical,
        onPageChanged: (index) {
          if (index < reels.length) {
            final reel = reels[index];
            _currentReelId = reel.id;
            _startViewTimer(reel.id ?? "47");
          }
        },
        itemBuilder: (context, index) {
          if (index == reels.length) {
            if (isLoading) {
              return Center(child: CircularProgressIndicator());
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
    );
  }
}
