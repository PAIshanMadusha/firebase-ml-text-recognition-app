import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class StripeStorage {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> storeSubscriptionDetails({
    required String customerId,
    required String email,
    required String userName,
    required String subscriptionId,
    required String paymentStatus,
    required DateTime startDate,
    required DateTime endDate,
    required String planId,
    required double amountPaid,
    required String currency,
    String? paymentMethod,
    String? subscriptionType,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? autoRenewal,
    String? cancellationReason,
    String? promoCode,
    Map<String, dynamic>? metadata,
  }) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      await _firebaseFirestore
          .collection("premiumUserDeatils")
          .doc(customerId)
          .set({
            "userId": userId,
            'customerId': customerId,
            'email': email,
            'userName': userName,
            'subscriptionId': subscriptionId,
            'paymentStatus': paymentStatus,
            'startDate': startDate,
            'endDate': endDate,
            'planId': planId,
            'amountPaid': amountPaid,
            'currency': currency,
            'paymentMethod': paymentMethod ?? '',
            'subscriptionType': subscriptionType ?? 'premium',
            'createdAt': createdAt ?? DateTime.now(),
            'updatedAt': updatedAt ?? DateTime.now(),
            'autoRenewal': autoRenewal ?? true,
            'cancellationReason': cancellationReason ?? '',
            'promoCode': promoCode ?? '',
            'metadata': metadata ?? {},
          });
      debugPrint("Premium User Details Saved Successfully!");
    } catch (error) {
      debugPrint("Error: $error");
    }
  }

  //Check Weather the UID is Premium
  Future<bool> checkIfPremium() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final QuerySnapshot snapshot =
          await _firebaseFirestore
              .collection("premiumUserDeatils")
              .where("userId", isEqualTo: userId)
              .get();

      return snapshot.docs.isNotEmpty;
    } catch (error) {
      debugPrint("Error: $error");
      return false;
    }
  }
}
