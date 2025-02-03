import 'package:flutter/material.dart';
import 'package:heroapp/pages/home_page/_components/reel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> urls = <String>[
      "assets/reels/a.mp4",
      "assets/reels/b.mp4",
      "assets/reels/c.mp4",
      "assets/reels/d.mp4",
      "assets/reels/e.mp4",
      "assets/reels/f.mp4",
      "assets/reels/g.mp4",
      "assets/reels/h.mp4"
    ];

    PageController controller = PageController(initialPage: 0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: controller,
        scrollDirection: Axis.vertical,
        itemCount: urls.length,
        itemBuilder: (context, index){
          return Reel(videoUrl: urls[index]);
        }
      ),
    );
  }
}
