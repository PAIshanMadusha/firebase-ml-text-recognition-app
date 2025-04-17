//Initialization
import 'package:firebase_ml_text_recognition_app/services/stripe/stripe_api_service.dart';
import 'package:firebase_ml_text_recognition_app/services/stripe/stripe_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> init({required String name, required String email}) async {
  //Create a New Customer
  Map<String, dynamic>? customer = await createCustomer(
    email: email,
    name: name,
  );
  if (customer == null || customer["id"] == null) {
    throw Exception("Faild to Create Customer");
  }

  //Create a Payment Intent
  Map<String, dynamic>? paymentIntent = await createPaymentIntent(
    customerId: customer["id"],
  );
  if (paymentIntent == null || paymentIntent["client_secret"] == null) {
    throw Exception("Failed to Create Payment Intent");
  }

  //Create a Credit Card
  await createCreditCard(
    customerId: customer["id"],
    clientSecret: paymentIntent["client_secret"],
  );

  //Retrieve Customer Payment Methods
  Map<String, dynamic>? customerPaymentMethods =
      await getCustomerPaymentMethods(customerId: customer["id"]);

  if (customerPaymentMethods == null ||
      customerPaymentMethods["data"].isEmpty) {
    throw Exception("Failed to Retrieve Customer Payment Methods");
  }

  //Create a Subscription
  Map<String, dynamic>? subscription = await createSubscription(
    customerId: customer["id"],
    paymentId: customerPaymentMethods["data"][0]["id"],
  );
  if (subscription == null || subscription["id"] == null) {
    throw Exception("Faild to Create Subscription");
  }

  //Store the Data in Firestore
  StripeStorage().storeSubscriptionDetails(
    customerId: customer["id"],
    email: email,
    userName: name,
    subscriptionId: subscription["id"],
    paymentStatus: "active",
    startDate: DateTime.now(),
    endDate: DateTime.now().add(Duration(days: 30)),
    planId: "price_1REmVySHefmHhg9lhKnukC5O",
    amountPaid: 2.85,
    currency: "USD",
    paymentMethod: "Credit Card",
  );
}

//Create a New Customer
Future<Map<String, dynamic>?> createCustomer({
  required String email,
  required String name,
}) async {
  final customerCreationResponce = await stripeApiService(
    requestMethod: ApiServiceMethodType.post,
    endpoint: "customers",
    requestBody: {
      "name": name,
      "email": email,
      "description": "Text Capture Pro Plan",
    },
  );
  return customerCreationResponce;
}

//Create a Payment Intent
Future<Map<String, dynamic>?> createPaymentIntent({
  required String customerId,
}) async {
  final paymentIntentCreationResponse = await stripeApiService(
    requestMethod: ApiServiceMethodType.post,
    endpoint: "setup_intents",
    requestBody: {
      "customer": customerId,
      "automatic_payment_methods[enabled]": "true",
    },
  );
  return paymentIntentCreationResponse;
}

//Create a Credit Card
Future<void> createCreditCard({
  required String customerId,
  required String clientSecret,
}) async {
  await Stripe.instance.initPaymentSheet(
    paymentSheetParameters: SetupPaymentSheetParameters(
      primaryButtonLabel: "subscribe \$2.85 Monthly",
      style: ThemeMode.light,
      merchantDisplayName: "Text Capture Pro Plan",
      customerId: customerId,
      setupIntentClientSecret: clientSecret,
    ),
  );
  await Stripe.instance.presentPaymentSheet();
}

//Retrieve Customer Payment Methods
Future<Map<String, dynamic>?> getCustomerPaymentMethods({
  required String customerId,
}) async {
  final customerPaymentMethodsResponse = await stripeApiService(
    requestMethod: ApiServiceMethodType.get,
    endpoint: "customers/$customerId/payment_methods",
  );
  return customerPaymentMethodsResponse;
}

//Create a Subscription
Future<Map<String, dynamic>?> createSubscription({
  required String customerId,
  required String paymentId,
}) async {
  final subscriptionCreationResponse = await stripeApiService(
    requestMethod: ApiServiceMethodType.post,
    endpoint: "subscriptions",
    requestBody: {
      "customer": customerId,
      "default_payment_method": paymentId,
      "items[0][price]": "price_1REmVySHefmHhg9lhKnukC5O",
    },
  );
  return subscriptionCreationResponse;
}
