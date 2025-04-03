import 'package:flutter/material.dart';

import '../../../models/reel.dart';
import '../../../repository/reel_repository.dart';
import 'liked_item.dart';

class SavedVideosPage extends StatefulWidget {
  final TabController tabController;
  final Function(Reel) onReelSelected;
  final Function() onSideMenuClick;
  const SavedVideosPage({super.key, required this.tabController, required this.onReelSelected, required this.onSideMenuClick});

  @override
  State<SavedVideosPage> createState() => _LikedVideosPageState();
}

class _LikedVideosPageState extends State<SavedVideosPage> {
  final ReelRepository reelRepository = ReelRepository();
  late Future<List<Reel>> likedVideos;

  @override
  void initState() {
    super.initState();
    likedVideos = reelRepository.getLikedVideos();
  }

  final collections = [
    {
      "collection_name": "Something new",
      "is_public": false,
      "thumbnail_url": "https://res.cloudinary.com/dqudeifns/image/upload/v1739424587/thumbnails/thumb1.jpg"
    },
    {
      "collection_name": "ASMR Videos",
      "is_public": false,
      "thumbnail_url": "https://res.cloudinary.com/dqudeifns/image/upload/v1739424587/thumbnails/thumb2.jpg"
    },
    {
      "collection_name": "Cool Videos",
      "is_public": true,
      "thumbnail_url": "https://res.cloudinary.com/dqudeifns/image/upload/v1739424587/thumbnails/thumb3.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,size: 34,),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.add, size: 34,),
            ),
          )
        ],
      ),
      body: FutureBuilder<List<Reel>>(
        future: likedVideos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<Reel> reels = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Text(
                          "Collections",
                          style: Theme.of(context).textTheme.titleLarge
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.chevron_right, size: 34,),
                        ),
                      ],
                    ),
                  ),
                  GridView.builder(
                    itemCount: collections.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    // padding: EdgeInsets.only(top: spacing),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      childAspectRatio: 100 / 40,
                    ),
                    itemBuilder: (context, index) {
                      final collection = collections[index];
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Image.network(collection["thumbnail_url"].toString()),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${collection["collection_name"]}"),
                                collection['is_public'] as bool ? Row(
                                  children: [
                                    Icon(Icons.people, size: 15, color: Colors.white54,),
                                    SizedBox(width: 10,),
                                    Text("Public", style: TextStyle(
                                        color: Colors.white54
                                    ),)
                                  ],
                                ) : Row(
                                  children: [
                                    Icon(Icons.lock, size: 15, color: Colors.white54,),
                                    SizedBox(width: 10,),
                                    Text("Private", style: TextStyle(
                                      color: Colors.white54
                                    ),)
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Text(
                          "Reels",
                          style: Theme.of(context).textTheme.titleLarge
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {},
                          child: Text("Manage", style: TextStyle(
                            color: Colors.blue
                          ),),
                        )
                      ],
                    ),
                  ),
                  GridView.builder(
                    itemCount: collections.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    // padding: EdgeInsets.only(top: spacing),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      childAspectRatio: 100 / 40,
                    ),
                    itemBuilder: (context, index) {
                      final collection = collections[index];
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Image.network(collection["thumbnail_url"].toString()),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${collection["collection_name"]}"),
                                collection['is_public'] as bool ? Row(
                                  children: [
                                    Icon(Icons.people, size: 15, color: Colors.white54,),
                                    SizedBox(width: 10,),
                                    Text("Public", style: TextStyle(
                                        color: Colors.white54
                                    ),)
                                  ],
                                ) : Row(
                                  children: [
                                    Icon(Icons.lock, size: 15, color: Colors.white54,),
                                    SizedBox(width: 10,),
                                    Text("Private", style: TextStyle(
                                        color: Colors.white54
                                    ),)
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  GridView.builder(
                    itemCount: collections.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    // padding: EdgeInsets.only(top: spacing),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      childAspectRatio: 100 / 40,
                    ),
                    itemBuilder: (context, index) {
                      final collection = collections[index];
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Image.network(collection["thumbnail_url"].toString()),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${collection["collection_name"]}"),
                                collection['is_public'] as bool ? Row(
                                  children: [
                                    Icon(Icons.people, size: 15, color: Colors.white54,),
                                    SizedBox(width: 10,),
                                    Text("Public", style: TextStyle(
                                        color: Colors.white54
                                    ),)
                                  ],
                                ) : Row(
                                  children: [
                                    Icon(Icons.lock, size: 15, color: Colors.white54,),
                                    SizedBox(width: 10,),
                                    Text("Private", style: TextStyle(
                                        color: Colors.white54
                                    ),)
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  GridView.builder(
                    itemCount: collections.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    // padding: EdgeInsets.only(top: spacing),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      childAspectRatio: 100 / 40,
                    ),
                    itemBuilder: (context, index) {
                      final collection = collections[index];
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Image.network(collection["thumbnail_url"].toString()),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${collection["collection_name"]}"),
                                collection['is_public'] as bool ? Row(
                                  children: [
                                    Icon(Icons.people, size: 15, color: Colors.white54,),
                                    SizedBox(width: 10,),
                                    Text("Public", style: TextStyle(
                                        color: Colors.white54
                                    ),)
                                  ],
                                ) : Row(
                                  children: [
                                    Icon(Icons.lock, size: 15, color: Colors.white54,),
                                    SizedBox(width: 10,),
                                    Text("Private", style: TextStyle(
                                        color: Colors.white54
                                    ),)
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  GridView.builder(
                    itemCount: collections.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    // padding: EdgeInsets.only(top: spacing),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      childAspectRatio: 100 / 40,
                    ),
                    itemBuilder: (context, index) {
                      final collection = collections[index];
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Image.network(collection["thumbnail_url"].toString()),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${collection["collection_name"]}"),
                                collection['is_public'] as bool ? Row(
                                  children: [
                                    Icon(Icons.people, size: 15, color: Colors.white54,),
                                    SizedBox(width: 10,),
                                    Text("Public", style: TextStyle(
                                        color: Colors.white54
                                    ),)
                                  ],
                                ) : Row(
                                  children: [
                                    Icon(Icons.lock, size: 15, color: Colors.white54,),
                                    SizedBox(width: 10,),
                                    Text("Private", style: TextStyle(
                                        color: Colors.white54
                                    ),)
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  GridView.builder(
                    itemCount: collections.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    // padding: EdgeInsets.only(top: spacing),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      childAspectRatio: 100 / 40,
                    ),
                    itemBuilder: (context, index) {
                      final collection = collections[index];
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Image.network(collection["thumbnail_url"].toString()),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${collection["collection_name"]}"),
                                collection['is_public'] as bool ? Row(
                                  children: [
                                    Icon(Icons.people, size: 15, color: Colors.white54,),
                                    SizedBox(width: 10,),
                                    Text("Public", style: TextStyle(
                                        color: Colors.white54
                                    ),)
                                  ],
                                ) : Row(
                                  children: [
                                    Icon(Icons.lock, size: 15, color: Colors.white54,),
                                    SizedBox(width: 10,),
                                    Text("Private", style: TextStyle(
                                        color: Colors.white54
                                    ),)
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  //   child: itemGrid(reels),
                  // ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget itemGrid(List<Reel> reels) {
    return SizedBox(
      child: GridView.builder(
        itemCount: reels.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          crossAxisCount: 2,
          childAspectRatio: (MediaQuery.of(context).size.width + 40) /
              (MediaQuery.of(context).size.height / 1.4),
        ),
        itemBuilder: (context, index) {
          return Center(
            child: LikedItem(
              reel: reels[index],
              onTap: () async {
                await widget.onReelSelected(reels[index]);
                if(context.mounted){
                  Navigator.pop(context);
                }
                widget.onSideMenuClick();
                Future.delayed(const Duration(milliseconds: 800), () {
                  widget.tabController.animateTo(1);
                });
              },
            )
          );
        },
      ),
    );
  }
}
