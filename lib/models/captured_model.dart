import 'package:cloud_firestore/cloud_firestore.dart';

class CapturedModel {
  final String userId;
  final String captureData;
  final DateTime capturedDate;
  final String imageUrl;

  CapturedModel({
    required this.userId,
    required this.captureData,
    required this.capturedDate,
    required this.imageUrl,
  });

  //Convert Dart Object to Json Data
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "captureData": captureData,
      "capturedDate": capturedDate,
      "imageUrl": imageUrl,
    };
  }

  //Convert Json Data to Dart Object
  factory CapturedModel.fromJson(Map<String, dynamic> json) {
    return CapturedModel(
      userId: json["userId"],
      captureData: json["captureData"],
      capturedDate: (json["capturedDate"] as Timestamp).toDate(),
      imageUrl: json["imageUrl"],
    );
  }
}
