import 'package:flutter/material.dart';

class LikedVideosPage extends StatefulWidget {
  const LikedVideosPage({super.key});

  @override
  State<LikedVideosPage> createState() => _LikedVideosPageState();
}

class _LikedVideosPageState extends State<LikedVideosPage> {
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
      appBar: AppBar(
        title: Text("Liked Videos", style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold
        )),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
        padding: EdgeInsets.only(top: 20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 25,
          crossAxisSpacing: 0,
          crossAxisCount: 2,
          childAspectRatio: (MediaQuery.of(context).size.width+40) / (MediaQuery.of(context).size.height / 1.4),
        ),
        itemBuilder: (context, index) {
          return Center(child: LikedItem(thumbnail: thumbnails[index],));
        },
      ),
    );
  }
}

class LikedItem extends StatefulWidget {
  final String thumbnail;
  const LikedItem({super.key, required this.thumbnail});

  @override
  State<LikedItem> createState() => _LikedItemState();
}

class _LikedItemState extends State<LikedItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(widget.thumbnail),
          ),
        ],
      ),
    );
  }
}

