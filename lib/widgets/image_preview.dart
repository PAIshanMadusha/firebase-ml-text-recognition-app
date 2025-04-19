import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImagePreview extends StatelessWidget {
  final String? imagePath;
  const ImagePreview({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
      ),
      child:
          imagePath == null
              ? Center(
                child: SvgPicture.asset(
                  "assets/undrawimages.svg",
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
              : ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.file(File(imagePath!), fit: BoxFit.cover),
              ),
    );
  }
}
