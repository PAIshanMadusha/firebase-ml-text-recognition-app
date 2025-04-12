import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_text_recognition_app/models/captured_model.dart';
import 'package:firebase_ml_text_recognition_app/services/capture_storage_service.dart';
import 'package:flutter/widgets.dart';

class CaptureFirestoreService {
  //Firebase Firestore & Auth Instaces
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //Store the Captured Data in the Firestore
  Future<void> storeCapturedData({
    required captureData,
    required capturedDate,
    required capturedImageFile,
  }) async {
    //Create a Anonymous User
    try {
      if (_firebaseAuth.currentUser == null) {
        await _firebaseAuth.signInAnonymously();
      }
      final userId = _firebaseAuth.currentUser!.uid;

      //Store the Image
      final imageUrl = await CaptureStorageService().uploadImage(
        capturedImage: capturedImageFile,
        userId: userId,
      );

      //Create a Reference to the Collection in the Firestore
      CollectionReference capturedText = _firebaseFirestore.collection(
        "capturedText",
      );

      final CapturedModel newCaptured = CapturedModel(
        userId: userId,
        captureData: captureData,
        capturedDate: capturedDate,
        imageUrl: imageUrl,
      );

      //Store the Data in the Firestore
      await capturedText.add(newCaptured.toJson());
    } catch (error) {
      debugPrint("Error: $error");
    }
  }

  //Get All the Captured Data
  Stream<List<CapturedModel>> getUserCapturedData() {
    try {
      final userId = _firebaseAuth.currentUser!.uid;
      return _firebaseFirestore
          .collection("capturedText")
          .where("userId", isEqualTo: userId)
          .snapshots()
          .map((snapshots) {
            return snapshots.docs.map((doc) {
              return CapturedModel.fromJson(doc.data());
            }).toList();
          });
    } catch (error) {
      debugPrint("Error: $error");
      return Stream.empty();
    }
  }
}
