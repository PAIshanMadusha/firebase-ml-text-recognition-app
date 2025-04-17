import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

enum ApiServiceMethodType { get, post }

const baseUrl = "https://api.stripe.com/v1";
final Map<String, String> requestHeaders = {
  'Content-Type': 'application/x-www-form-urlencoded',
  'Authorization': 'Bearer ${dotenv.env['SECRET_KEY']}',
};

Future<Map<String, dynamic>?> stripeApiService({
  required ApiServiceMethodType requestMethod,
  Map<String, dynamic>? requestBody,
  required String endpoint,
}) async {
  final requestUrl = "$baseUrl/$endpoint";
  try {
    final requestResponse =
        requestMethod == ApiServiceMethodType.get
            ? await http.get(Uri.parse(requestUrl), headers: requestHeaders)
            : await http.post(
              Uri.parse(requestUrl),
              headers: requestHeaders,
              body: requestBody,
            );
    if (requestResponse.statusCode == 200) {
      return json.decode(requestResponse.body);
    } else {
      debugPrint(requestResponse.body);
      throw Exception("Failed to Fetch Data: ${requestResponse.body}");
    }
  } catch (error) {
    debugPrint("Error: $error");
    return null;
  }
}
