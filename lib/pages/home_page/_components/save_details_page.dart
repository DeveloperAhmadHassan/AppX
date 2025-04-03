import 'package:flutter/material.dart';
import 'package:loopyfeed/utils/extensions/color.dart';

import '../../../utils/constants.dart';

class SaveDetailsPage extends StatefulWidget {
  final String thumbnailUrl;
  const SaveDetailsPage({super.key, required this.thumbnailUrl});

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
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            color: Colors.black.withValues(alpha: 0.6),
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
                    Text("Save", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: canBeSaved ? HexColor.fromHex(AppConstants.primaryColor) : Colors.grey
                    ),)
                  ],
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black
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
                            Switch(value: isPublic, onChanged: (value) {
                              setState(() {
                                isPublic = value;
                              });
                            },
                              activeColor: HexColor.fromHex(AppConstants.primaryColor),
                            )
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
