import 'package:firebase_ml_text_recognition_app/provider/premium_provider.dart';
import 'package:firebase_ml_text_recognition_app/widgets/show_premium_page_widget.dart';
import 'package:firebase_ml_text_recognition_app/widgets/user_history_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextCaptureHistoryPage extends StatelessWidget {
  const TextCaptureHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isPremiumProvider = Provider.of<PremiumProvider>(context);

    //Check If the Premium Status is not Loaded Yet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isPremiumProvider.checkPremiumStates();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Captured History"),
        actions: [
          isPremiumProvider.isPremium
              ? Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(Icons.workspace_premium, color: Colors.amber),
              )
              : SizedBox(),
        ],
      ),
      body:
          isPremiumProvider.isPremium
              ? const UserHistoryWidget()
              : ShowPremiumPageWidget(),
    );
  }
}
