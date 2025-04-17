import 'package:firebase_ml_text_recognition_app/services/stripe/stripe_storage.dart';
import 'package:flutter/material.dart';

class PremiumProvider with ChangeNotifier{
  bool _isPremium = false;
  bool get isPremium => _isPremium;

  Future <void> checkPremiumStates()async{
    _isPremium = await StripeStorage().checkIfPremium();
    notifyListeners();
  }

  void activePremium(){
    _isPremium = true;
    notifyListeners();
  }
}