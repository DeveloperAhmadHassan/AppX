import 'package:flutter/material.dart';
import 'package:loopyfeed/models/saved_collection.dart';
import 'package:loopyfeed/pages/side_page/saved_videos_page/collections_page.dart';
import 'package:loopyfeed/pages/side_page/saved_videos_page/functions.dart';
import 'package:loopyfeed/pages/side_page/saved_videos_page/globals.dart';
import 'package:loopyfeed/pages/side_page/saved_videos_page/manage_saved_item.dart';
import 'package:loopyfeed/utils/components/no_items_found.dart';
import 'package:loopyfeed/utils/constants.dart';
import 'package:loopyfeed/utils/extensions/color.dart';

import '../../../models/reel.dart';
import '../../../repository/reel_repository.dart';
import 'collections_bottom_sheet.dart';
import 'saved_item.dart';

class ManageSavedVideosPage extends StatefulWidget {
  final TabController tabController;
  final Function(Reel) onReelSelected;
  final Function() onSideMenuClick;
  const ManageSavedVideosPage({super.key, required this.tabController, required this.onReelSelected, required this.onSideMenuClick});

  @override
  State<ManageSavedVideosPage> createState() => _LikedVideosPageState();
}

class _LikedVideosPageState extends State<ManageSavedVideosPage> {
  final ReelRepository reelRepository = ReelRepository();
  late Future<List<Reel>> savedVideos;

  @override
  void initState() {
    super.initState();
    savedVideos = reelRepository.getSavedVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,size: 34,),
          onPressed: () {
            emptyList();
            Navigator.pop(context, true);
          },
        ),
        title: ValueListenableBuilder(
          valueListenable: manageReels,
          builder: (context, value, child) {
            return value.isEmpty
              ? Text(
            "Manage Saved Videos",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),)
              : Text(
            "${value.length}   selected",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),);
          }),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<Reel>>(
              future: savedVideos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  List<Reel> reels = snapshot.data!;

                  return reels.isNotEmpty ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                        child: itemGrid(reels),
                      ),
                    ],
                  ) : NoItemsFound(tabController: widget.tabController, onSideMenuClick: widget.onSideMenuClick, pageTitle: "", title: "No Saved Videos Found!");
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.withValues(alpha: 0.2) : Colors.grey,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: ValueListenableBuilder(
            valueListenable: manageReels,
            builder: (context, value, child) {
              return Row(
                children: [
                  Expanded(child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: value.isNotEmpty ? HexColor.fromHex(AppConstants.primaryColor) : HexColor.fromHex(AppConstants.graySwatch1),
                        borderRadius: BorderRadius.circular(100)
                    ),
                    child: Text("Unsave", style: TextStyle(
                        color: HexColor.fromHex(AppConstants.primaryBlack),
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),textAlign: TextAlign.center,),
                  )),
                  SizedBox(width: 15,),
                  Expanded(child: InkWell(
                    onTap: (){
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        constraints: BoxConstraints(
                          maxHeight: 300,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (BuildContext context) {
                          return CollectionsBottomSheet(
                            reelId: int.parse("1"),
                            thumbnailUrl: "",
                            onToggleSave: () {
                              setState(() {
                                // isCurrentlySaved = !isCurrentlySaved;
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: value.isNotEmpty ? HexColor.fromHex(AppConstants.primaryColor) : HexColor.fromHex(AppConstants.graySwatch1),
                          borderRadius: BorderRadius.circular(100)
                      ),
                      child: Text("Add to collection", style: TextStyle(
                          color: HexColor.fromHex(AppConstants.primaryBlack),
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),textAlign: TextAlign.center,),
                    ),
                  )),
                ],
              );
            },
          ),
        ),
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
            child: ManageSavedItem(
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
