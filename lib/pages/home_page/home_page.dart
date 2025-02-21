import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:heroapp/pages/home_page/_components/home_reel_item.dart';
import '../../controllers/home_reel_controller.dart';
import '../../models/reel.dart';

class HomePage extends StatefulWidget {
  final Reel? reel;
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
  bool _error = false;

  @override
  void initState() {
    super.initState();
    reels = [];
    if(widget.reel != null) {
      reels.insert(0, widget.reel!);
    } else if (widget.reel == null){
      print("Reel is null");
    }
    fetchReels(currentPage);
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.reel != oldWidget.reel) {
      setState(() {
        reels.clear();
        if(widget.reel != null) {
          reels.insert(0, widget.reel!);
        }
        fetchReels(currentPage);
      });
    }
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
        _error = true;
      });
      print('Error fetching reels: $e');
    }
  }

  void _startViewTimer(String reelId) {
    _viewTimer?.cancel();

    _viewTimer = Timer(Duration(seconds: 3), () async {
      if (_currentReelId == reelId) {
        viewedReels.add(reelId);
        await apiController.incrementViews(reelId);
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
            _startViewTimer(reel.id ?? "49");
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
                )
              );
            }
            else {
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
