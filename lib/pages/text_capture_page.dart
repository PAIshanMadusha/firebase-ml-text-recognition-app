import 'dart:io';
import 'package:firebase_ml_text_recognition_app/services/capture_firestore_service.dart';
import 'package:firebase_ml_text_recognition_app/widgets/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
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
      backgroundColor: Colors.green,
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
              title: Text(
                "Select from Gallery",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
              leading: Icon(Icons.photo_library, size: 30, color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(color: Colors.white),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                _pickImage(source: ImageSource.camera);
              },
              title: Text(
                "Select from Camera",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
              leading: Icon(Icons.camera, size: 30, color: Colors.white),
            ),
          ],
        );
      },
    );
  }

  //Text Recognizer
  late TextRecognizer textRecognizer;
  String recognizedText = "";
  bool isRecognizing = false;

  //Method to Process the Picked Image
  void _processImage() async {
    if (pickedImagePath == null) {
      return;
    }
    setState(() {
      isRecognizing = true;
      recognizedText = "";
    });
    try {
      final inputImage = InputImage.fromFilePath(pickedImagePath!);
      final RecognizedText recognizedTextFromModel = await textRecognizer
          .processImage(inputImage);

      //Loop Through the Recognized Text
      for (TextBlock block in recognizedTextFromModel.blocks) {
        for (TextLine line in block.lines) {
          recognizedText += "${line.text} \n";
        }
      }
      //Store the Data
      if (recognizedText.isNotEmpty) {
        try {
          await CaptureFirestoreService().storeCapturedData(
            captureData: recognizedText,
            capturedDate: DateTime.now(),
            capturedImageFile: File(pickedImagePath!),
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Text Captured Successfully!")),
            );
          }
        } catch (error) {
          debugPrint("Error: $error");
        }
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      debugPrint("Error: $error");
    } finally {
      setState(() {
        isRecognizing = false;
      });
    }
  }

  //Copy to Clipboard
  void _copyToClipboard() async {
    if (recognizedText.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: recognizedText));
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Text Copied to Clipboard")));
    }
  }

  @override
  void initState() {
    imagePicker = ImagePicker();
    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Image Text Capture",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            ImagePreview(imagePath: pickedImagePath),
            SizedBox(height: 15),
            if (!isImagePicked)
              ElevatedButton(
                onPressed: _selectImageModel,
                child: Text(
                  "Pick an Image",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            if (isImagePicked)
              ElevatedButton(
                onPressed: isRecognizing ? null : _processImage,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Capture Text",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (isRecognizing) ...[
                      SizedBox(width: 20),
                      SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recognized Text",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: _copyToClipboard,
                  icon: Icon(Icons.copy, size: 30),
                ),
              ],
            ),
            if (!isRecognizing) ...[
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child:
                        recognizedText.isEmpty
                            ? Padding(
                              padding: const EdgeInsets.only(top: 70),
                              child: SvgPicture.asset(
                                "assets/textfile.svg",
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                            : SelectableText(
                              recognizedText,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
