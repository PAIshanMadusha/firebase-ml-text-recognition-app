import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';

class CaptureStorageService {
  //Firebase Storage Instace
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  //Store the Captured Image in Storage
  Future<String> uploadImage({required capturedImage, required userId}) async {
    Reference ref = _firebaseStorage
        .ref()
        .child("captured")
        .child("$userId/${DateTime.now()}");

    try {
      UploadTask task = ref.putFile(
        capturedImage,
        SettableMetadata(contentType: "image/jpeg"),
      );
      TaskSnapshot snapshot = await task;
      String refUrl = await snapshot.ref.getDownloadURL();

      return refUrl;
    } catch (error) {
      debugPrint("Error: $error");
      return "";
    }
  }
}
