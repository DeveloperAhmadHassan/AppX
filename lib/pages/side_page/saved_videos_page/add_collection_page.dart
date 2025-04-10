import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loopyfeed/utils/constants.dart';
import 'package:loopyfeed/utils/extensions/color.dart';
import 'package:loopyfeed/utils/extensions/string.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class AddCollectionPage extends StatefulWidget {
  const AddCollectionPage({super.key});

  @override
  State<AddCollectionPage> createState() => _AddCollectionPageState();
}

class _AddCollectionPageState extends State<AddCollectionPage> {
  bool _isDisabled = true;
  bool _nameError = false;
  String _nameErrorHelper = "Error Occurred";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
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
          ],
        ),
      ),
    );
  }
}
