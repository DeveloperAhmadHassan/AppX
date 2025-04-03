import 'package:flutter/material.dart';
import 'package:loopyfeed/pages/home_page/_components/save_details_page.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../utils/constants.dart';
import '../../../utils/extensions/color.dart';

class BookmarkBottomSheet extends StatelessWidget {
  final bool isSaved;
  final String thumbnailUrl;
  final VoidCallback onToggleSave;

  const BookmarkBottomSheet({super.key, required this.isSaved, required this.thumbnailUrl, required this.onToggleSave});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 900,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white10,
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
                          child: Image.network(thumbnailUrl),
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
                              color: Colors.white54
                          ))
                        ],
                      ),
                      Spacer(),
                      InkWell(
                        onTap: onToggleSave,
                        child: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border_rounded, size: 40,),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Column(
              children: [
                Icon(Symbols.group_add_rounded, size: 70, weight: 300,),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 16.0),
            child: Column(
              children: [
                Text("Make your collections public", style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                ),textAlign: TextAlign.center,),
                Text("Create a collection for people. Everyone can add or remove posts.", style: TextStyle(
                    color: Colors.white70
                ), textAlign: TextAlign.center,),
              ],
            ),
          ),
          Spacer(),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 40),
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SaveDetailsPage(thumbnailUrl: thumbnailUrl)));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: HexColor.fromHex(AppConstants.primaryColor)
                  ),
                  child: Text("Try It", style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),textAlign: TextAlign.center,),
                ),
              )
          ),
          // SizedBox(height: 20,),
        ],
      ),
    );
  }
}