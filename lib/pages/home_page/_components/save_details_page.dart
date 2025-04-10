import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:loopyfeed/models/saved_collection.dart';
import 'package:loopyfeed/pages/side_page/saved_videos_page/saved_videos_by_collection_page.dart';
import 'package:loopyfeed/utils/extensions/color.dart';

import '../../../repository/reel_repository.dart';
import '../../../utils/constants.dart';

class SaveDetailsPage extends StatefulWidget {
  final String thumbnailUrl;
  final int reelId;
  final bool isPublic;

  final BuildContext parentContext;
  const SaveDetailsPage({super.key, required this.thumbnailUrl, required this.reelId, this.isPublic = false, required this.parentContext});

  @override
  State<SaveDetailsPage> createState() => _SaveDetailsPageState();
}

class _SaveDetailsPageState extends State<SaveDetailsPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isPublic = false;
  bool canBeSaved = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
    _controller.addListener(() {
      setState(() {
        canBeSaved = _controller.text.trim().isNotEmpty;
      });
    });
    isPublic = widget.isPublic;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ReelRepository reelRepository = ReelRepository();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.thumbnailUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Container(
            color: HexColor.fromHex(AppConstants.primaryBlack).withValues(alpha: 0.6),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 35.0, left: 25.0, right: 25.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Text("Cancel", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),),
                    ),
                    Text("New Collection", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),),
                    GestureDetector(
                      onTap: () async {
                        var res = reelRepository.addCollection(_controller.text, isPublic: isPublic, reelId: widget.reelId, thumbnailUrl: widget.thumbnailUrl);
                        SavedCollection collection = SavedCollection(id: await res, thumbnailUrl: widget.thumbnailUrl, collectionName: _controller.text, isPublic: isPublic ? 1 : 0);
                        Navigator.pop(context);
                        Navigator.pop(context);

                        final snackBar = SnackBar(
                          content: RichText(text: TextSpan(
                            style: Theme.of(context).textTheme.titleLarge,
                            children: [
                              TextSpan(text: 'Reel Added to '),
                              TextSpan(text: _controller.text, style: TextStyle(color: HexColor.fromHex(AppConstants.primaryColor))),
                            ]
                          )),
                          backgroundColor: Colors.teal,
                          behavior: SnackBarBehavior.floating,
                          action: SnackBarAction(label: "View", onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SavedVideosByCollectionPage(collection: collection)));
                          }),
                        );

                        Future.delayed(Duration(milliseconds: 200), (){
                          ScaffoldMessenger.of(widget.parentContext).showSnackBar(snackBar);
                        });
                      },
                      child: Text("Save", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: canBeSaved ? HexColor.fromHex(AppConstants.primaryColor) : Colors.grey
                      ),),
                    )
                  ],
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: HexColor.fromHex(AppConstants.backgroundDark)
                  ),
                  child: Form(
                    child: Column(
                      children: [
                        TextFormField(
                          focusNode: _focusNode,
                          controller: _controller,
                          decoration: InputDecoration(
                            labelText: "Collection Name",
                          ),
                        ),
                        Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Collaborative", style: TextStyle(
                                  fontSize: 19
                                ),),
                                Text("Allow Public Access", style: TextStyle(
                                    color: Colors.white54
                                ),),
                              ],
                            ),
                            Spacer(),
                            FlutterSwitch(
                              height: 30,
                              width: 50,
                              padding: 3,
                              toggleSize: 20,
                              value: isPublic,
                              onToggle: (val) {
                                setState(() {
                                  isPublic = val;
                                });
                              },
                              activeColor: HexColor.fromHex(AppConstants.primaryBlack),
                              inactiveColor: HexColor.fromHex(AppConstants.graySwatch1),
                              activeSwitchBorder: Border.all(color: HexColor.fromHex(AppConstants.primaryBlack), width: 2),
                              toggleColor: HexColor.fromHex(AppConstants.primaryColor),
                              activeToggleColor: HexColor.fromHex(AppConstants.primaryColor),
                              inactiveToggleColor: HexColor.fromHex(AppConstants.primaryWhite),
                              inactiveSwitchBorder: Border.all(color: HexColor.fromHex(AppConstants.graySwatch1), width: 2),
                            )
                            // Switch(value: isPublic, onChanged: (value) {
                            //   setState(() {
                            //     isPublic = value;
                            //   });
                            // },
                            //   activeColor: HexColor.fromHex(AppConstants.primaryColor),
                            // )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
