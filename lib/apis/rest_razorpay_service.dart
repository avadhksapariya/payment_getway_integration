import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class RESTRazorpayService {
  static const String razorPayUrl = "https://api.razorpay.com/v1/orders";
  final razorPayKey = dotenv.get("KEY_ID");
  final razorPaySecret = dotenv.get("KEY_SECRET");

  Future<Map<String, dynamic>?> razorPayApi(num amount, String receiptId) async {
    const String tag = 'post_razorpay';
    Map<String, dynamic>? data;

    final auth = 'Basic${base64Encode(utf8.encode("$razorPayKey:$razorPaySecret"))}';
    log('$tag AUTH: $auth');

    final url = Uri.parse(razorPayUrl);
    log('$tag POST URL: $url');

    final header = {'content-type': 'application/json', 'Authorization': auth};
    log('$tag header: $header');

    final body = json.encode({"amount": amount * 100, "currency": "INR", "receipt": receiptId});
    log('$tag body: $body');

    try {
      var request = http.Request("POST", url);

      request.body = body;
      request.headers.addAll(header);

      http.StreamedResponse response = await request.send();

      final responseString = await response.stream.bytesToString();
      log('$tag Response: $responseString');

      if (response.statusCode == 200) {
        final decodedResult = json.decode(responseString);
        data = {"status": "success", "body": decodedResult};
      } else {
        data = {"status": "fail", "message": response.reasonPhrase};
      }
    } catch (e) {
      log('$tag Error: $e');
    }
    return data;
  }
}
