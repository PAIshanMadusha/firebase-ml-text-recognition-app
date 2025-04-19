import 'package:firebase_ml_text_recognition_app/models/captured_model.dart';
import 'package:firebase_ml_text_recognition_app/services/capture_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserHistoryWidget extends StatelessWidget {
  const UserHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<CapturedModel>>(
        stream: CaptureFirestoreService().getUserCapturedData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final capturedData = snapshot.data;
          if (capturedData == null || capturedData.isEmpty) {
            return Center(child: Text("No Captured Data Found!"));
          }
          return ListView.builder(
            itemCount: capturedData.length,
            itemBuilder: (context, index) {
              final capturedone = capturedData[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // ignore: deprecated_member_use
                  color: Colors.grey.withOpacity(0.1),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          capturedone.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.greenAccent,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.broken_image, size: 20);
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              capturedone.captureData.length > 200
                                  ? "${capturedone.captureData.substring(0, 200)}..."
                                  : capturedone.captureData,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: capturedone.captureData),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Text Copied to Clipboard!"),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.copy,
                              size: 30,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Captured on: ${capturedone.capturedDate.toLocal().toString().split(" ")[0]}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
