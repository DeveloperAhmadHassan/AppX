import 'package:flutter/material.dart';
import 'package:loopyfeed/pages/home_page/_components/save_details_page.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../models/saved_collection.dart';
import '../../../repository/reel_repository.dart';
import '../../../utils/constants.dart';
import '../../../utils/extensions/color.dart';
import '../../side_page/saved_videos_page/saved_videos_by_collection_page.dart';

class BookmarkBottomSheet extends StatefulWidget {
  final bool isSaved;
  final String thumbnailUrl;
  final int reelId;
  final VoidCallback onToggleSave;

  final BuildContext parentContext;

  const BookmarkBottomSheet({super.key, required this.isSaved, required this.thumbnailUrl, required this.onToggleSave, required this.reelId, required this.parentContext});

  @override
  State<BookmarkBottomSheet> createState() => _BookmarkBottomSheetState();
}

class _BookmarkBottomSheetState extends State<BookmarkBottomSheet> {
  final ReelRepository reelRepository = ReelRepository();
  late Future<List<SavedCollection>> collections;
  bool foundCollections = false;

  @override
  void initState() {
    super.initState();
    collections = reelRepository.getCollections();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 900,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.black12,
            child: Column(
              children: [
                SizedBox(height: 18,),
                Icon(Icons.maximize_rounded, size: 35, color: Colors.grey,),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 15),
                  child: Row(
                    children: [
                      Container(
                        height: 85,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade200,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(widget.thumbnailUrl),
                        ),
                      ),
                      SizedBox(width: 15,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Saved", style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19
                          ),),
                          Text("Private", style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black54
                          ))
                        ],
                      ),
                      Spacer(),
                      InkWell(
                        onTap: widget.onToggleSave,
                        child: Icon(widget.isSaved ? Icons.bookmark : Icons.bookmark_border_rounded, size: 40,),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          FutureBuilder<List<SavedCollection>>(
            future: collections,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Expanded(child: Center(child: CircularProgressIndicator()));
              } else if (snapshot.hasData && snapshot.data != null) {
                final collections = snapshot.data!;
                final foundCollections = collections.isNotEmpty;

                return Expanded(
                  child: Column(
                    children: [
                      foundCollections
                          ? Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 13.0),
                                child: Row(
                                  children: [
                                    Text("Collections", style: Theme.of(context).textTheme.titleLarge),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => SaveDetailsPage(
                                                  thumbnailUrl: widget.thumbnailUrl, reelId: widget.reelId, parentContext: widget.parentContext,
                                                )));
                                      },
                                      child: Text(
                                        "New Collection",
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: HexColor.fromHex(AppConstants.primaryColor)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                itemCount: collections.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final collection = collections[index];
                                  return InkWell(
                                    onTap: () async {
                                      await reelRepository.addToCollection(collection.id, widget.reelId);

                                      Navigator.pop(context, collection);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 60,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Image.network(collection.thumbnailUrl),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(collection.collectionName),
                                              collection.isPublic == 1
                                                  ? Row(
                                                children: [
                                                  Icon(Icons.people, size: 15, color: Colors.white54),
                                                  SizedBox(width: 10),
                                                  Text("Public", style: TextStyle(color: Colors.white54)),
                                                ],
                                              )
                                                  : Row(
                                                children: [
                                                  Icon(Icons.lock, size: 15, color: Colors.white54),
                                                  SizedBox(width: 10),
                                                  Text("Private", style: TextStyle(color: Colors.white54)),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Icon(Icons.add_circle_outline_rounded),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                          : Expanded(
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(height: 100),
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? HexColor.fromHex(AppConstants.primaryWhite)
                                        : HexColor.fromHex(AppConstants.primaryBlack),
                                    width: 3,
                                  ),
                                ),
                                child: Icon(Symbols.group_add_rounded, size: 70, weight: 300),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 16.0),
                                child: Column(
                                  children: [
                                    Text("Make your collections public",
                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center),
                                    Text("Create a collection for people. Everyone can add or remove posts.",
                                        style: TextStyle(color: Colors.white70), textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 40),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SaveDetailsPage(
                                  thumbnailUrl: widget.thumbnailUrl,
                                  reelId: widget.reelId, parentContext: widget.parentContext,
                                ),
                              ),
                            );
                          },
                          child: foundCollections
                              ? InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SaveDetailsPage(
                                        thumbnailUrl: widget.thumbnailUrl, reelId: widget.reelId, isPublic: true, parentContext: widget.parentContext,
                                  )));
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10), color: Colors.grey),
                                      child: Icon(Symbols.bookmark_border_rounded),
                                    ),
                                    SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Create a collaborative collection", style: Theme.of(context).textTheme.titleLarge,),
                                        Text("Save posts to a public collection", style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.white54
                                              : Colors.black54,
                                        ),),
                                      ],
                                    ),
                                    Spacer(),
                                    Icon(Icons.chevron_right, size: 35),
                                  ],
                                ),
                              ) : Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: HexColor.fromHex(
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppConstants.primaryColor
                                    : AppConstants.primaryBlack,
                              ),
                            ),
                            child: Text(
                              "Try It",
                              style: TextStyle(
                                color: HexColor.fromHex(
                                  Theme.of(context).brightness == Brightness.dark
                                      ? AppConstants.primaryBlack
                                      : AppConstants.primaryWhite,
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Expanded(child: Center(child: Text("Something went wrong.")));
              }
            },
          )
        ],
      ),
    );
  }
}