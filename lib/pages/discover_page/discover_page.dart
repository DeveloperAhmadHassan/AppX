import 'package:flutter/material.dart';

import '_components/discover_item.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final List<String> thumbnails = [
    'assets/thumbnails/a.jpg',
    'assets/thumbnails/b.jpg',
    'assets/thumbnails/c.jpg',
    'assets/thumbnails/d.jpg',
    'assets/thumbnails/b.jpg',
    'assets/thumbnails/c.jpg',
    'assets/thumbnails/a.jpg',
    'assets/thumbnails/d.jpg',
    'assets/thumbnails/c.jpg',
    'assets/thumbnails/a.jpg',
    'assets/thumbnails/b.jpg',
    'assets/thumbnails/d.jpg',
    'assets/thumbnails/a.jpg',
    'assets/thumbnails/b.jpg',
    'assets/thumbnails/c.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
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
              child: itemGrid(),
            )
          ],
        ),
      ),
    );
  }
  Widget itemGrid() {
    return SizedBox(
      child: GridView.builder(
        itemCount: thumbnails.length,
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
          return Center(child: DiscoverItem(thumbnail: thumbnails[index],));
        },
      ),
    );
  }
}