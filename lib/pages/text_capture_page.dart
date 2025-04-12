import 'package:firebase_ml_text_recognition_app/widgets/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextCapturePage extends StatefulWidget {
  const TextCapturePage({super.key});

  @override
  State<TextCapturePage> createState() => _TextCapturePageState();
}

class _TextCapturePageState extends State<TextCapturePage> {
  //Image Picker
  late ImagePicker imagePicker;
  String? pickedImagePath;
  bool isImagePicked = false;

  void _pickImage({required ImageSource source}) async {
    final pickedImage = await imagePicker.pickImage(source: source);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      pickedImagePath = pickedImage.path;
      isImagePicked = true;
    });
  }

  //Show Bottomsheet to Pick the Image
  void _selectImageModel() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                Navigator.pop(context);
                _pickImage(source: ImageSource.gallery);
              },
              title: Text("Select from Gallery"),
              leading: Icon(Icons.photo_library),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                _pickImage(source: ImageSource.camera);
              },
              title: Text("Select from Camera"),
              leading: Icon(Icons.camera),
            ),
          ],
        );
      },
    );
  }



  @override
  void initState() {
    imagePicker = ImagePicker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Text Capture")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              ImagePreview(imagePath: pickedImagePath),
              SizedBox(height: 15),
              if (!isImagePicked)
                ElevatedButton(
                  onPressed: _selectImageModel,
                  child: Text("Pick an Image"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
