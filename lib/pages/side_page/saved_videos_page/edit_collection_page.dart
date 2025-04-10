import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loopyfeed/models/saved_collection.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../utils/constants.dart';
import '../../../utils/extensions/color.dart';

class EditCollectionPage extends StatefulWidget {
  final SavedCollection collection;
  const EditCollectionPage({super.key, required this.collection});

  @override
  State<EditCollectionPage> createState() => _EditCollectionPageState();
}

class _EditCollectionPageState extends State<EditCollectionPage> {
  bool _isDisabled = false;
  bool _nameError = false;
  String _nameErrorHelper = "Error Occurred";
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.collection.collectionName);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.close, size: 35,),
        ),
        title: Text("Create Collection", style: TextStyle(
            fontSize: 22
        ),),
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Symbols.check, color: _isDisabled ? HexColor.fromHex(AppConstants.primaryColor).withValues(alpha: 0.3) : HexColor.fromHex(AppConstants.primaryColor), size: 35, weight: 900,),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(widget.collection.thumbnailUrl,),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Center(
              child: InkWell(
                onTap: (){},
                child: Text("Change Cover", style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryColor) : HexColor.fromHex(AppConstants.primaryBlack)
                ),),
              ),
            ),
            Text("Name", style: TextStyle(
                fontSize: 22
            ),),
            SizedBox(height: 15,),
            TextFormField(
              cursorColor: HexColor.fromHex(AppConstants.primaryColor),
              controller: _nameController,
              style: TextStyle(color: HexColor.fromHex(AppConstants.primaryWhite)),
              keyboardType: TextInputType.name,
              inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
              onChanged: (String value) {
                setState(() {
                  if (_nameController.text.isNotEmpty) {
                    _isDisabled = false;
                  } else {
                    _isDisabled = true;
                  }
                });
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                hintText: "Collection name",
                hintStyle: TextStyle(color: Colors.white70),
                fillColor: Theme.of(context).brightness == Brightness.light ? HexColor.fromHex(AppConstants.primaryBlack) : HexColor.fromHex(AppConstants.graySwatch1),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide.none,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: _nameError ? BorderSide(color: Colors.red, width: 2) : BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 25,),
            Divider(),
            SizedBox(height: 25,),
            InkWell(
              onTap: (){},
              child: Text("Delete Collection", style: TextStyle(
                  fontSize: 22,
                  // fontWeight: FontWeight.bold,
                  color: Colors.red
              ),),
            ),
            SizedBox(height: 10,),
            Text("When you delete this collection, the photos and videos will still be saved", style: TextStyle(
                fontSize: 17,
                color: HexColor.fromHex(AppConstants.graySwatch1)
            ),),
          ],
        ),
      ),
    );
  }
}
