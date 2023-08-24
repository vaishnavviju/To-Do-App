import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UserImgPicker extends StatefulWidget {
  const UserImgPicker({super.key, required this.onPickImage});
  final void Function(File pickedImg) onPickImage;
  @override
  State<UserImgPicker> createState() {
    return _UserImgState();
  }
}

class _UserImgState extends State<UserImgPicker> {
  File? _pickedImgFile;
  void _pickImage() async {
    final pickedImg = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImg == null) {
      return;
    }
    setState(() {
      _pickedImgFile = File(pickedImg.path);
    });
    widget.onPickImage(_pickedImgFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedImgFile != null ? FileImage(_pickedImgFile!) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          label: Text(
            'Add your image',
            style: GoogleFonts.montserrat(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          icon: const Icon(
            Icons.camera_alt_sharp,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
