import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../utils/assets.dart';
import '../../../utils/constants.dart';
import '../../../utils/extensions/color.dart';

class ProfileImagePicker extends StatefulWidget {
  final File? image;
  final String defaultImagePath;
  final ValueChanged<File?> onImagePicked;

  const ProfileImagePicker({
    super.key,
    required this.image,
    required this.onImagePicked,
    required this.defaultImagePath,
  });

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        widget.onImagePicked(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 120.0,
        height: 120.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: widget.defaultImagePath.toString().contains("assets/") ? null : Border.all(
            color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryBlack),
            width: 3.0,
          ),
        ),
        child: ClipOval(
          child: widget.image == null
              ? widget.defaultImagePath.toString().contains("assets/")
              ? Icon(Symbols.account_circle_filled_rounded, size: 120, weight: 300, color: HexColor.fromHex(AppConstants.primaryBlack),)
              : Image.file(
            File(widget.defaultImagePath),
            width: 120.0,
            height: 120.0,
            fit: BoxFit.cover,
          )
              : Image.file(
            widget.image!,
            width: 120.0,
            height: 120.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
