import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final String? imagePath;
  const ImagePreview({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child:
          imagePath == null
              ? Icon(Icons.photo)
              : Image.file(File(imagePath!), fit: BoxFit.cover),
    );
  }
}
