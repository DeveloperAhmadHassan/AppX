import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../utils/assets.dart';

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
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
            width: 3.0,
          ),
        ),
        child: ClipOval(
          child: widget.image == null
              ? widget.defaultImagePath.toString().contains("assets/")
              ? Image.asset(
            Assets.profilePA,
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover,
          )
              : Image.file(
            File(widget.defaultImagePath),
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover,
          )
              : Image.file(
            widget.image!,
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
