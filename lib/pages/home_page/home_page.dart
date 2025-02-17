import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:heroapp/pages/home_page/_components/home_reel_item.dart';
import '../../controllers/home_reel_controller.dart';
import '../../models/reel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Reel> reels;
  bool isLoading = false;
  int currentPage = 1;
  int nextPage = 1;
  // int totalPages = 1;
  final HomeReelController apiController = HomeReelController(Dio());

  @override
  void initState() {
    super.initState();
    reels = [];
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
        // totalPages = pagination['totalPages'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching reels: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        itemCount: reels.length + 1,
        controller: PageController(initialPage: 0),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          if (index == reels.length) {
            if (isLoading) {
              return Center(child: CircularProgressIndicator());
            } else {
              // Using post-frame callback to delay the API call after the build phase
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
