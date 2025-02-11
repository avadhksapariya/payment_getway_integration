import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:payment_getway_integration/models/model_razorpay_response.dart';
import 'package:payment_getway_integration/razorpay/razorpay_helper.dart';

class RESTRazorpayService {
  static const String razorPayUrl = "https://api.razorpay.com/v1/orders";
  final razorPayKey = dotenv.get("KEY_ID");
  final razorPaySecret = dotenv.get("KEY_SECRET");

  Future<ModelRazorPayResponse?> createOrder(num amount, String receiptId) async {
    const String tag = 'post_razorpay_order';
    ModelRazorPayResponse? data;

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
      log('$tag response: $responseString');

      final decodedResult = json.decode(responseString);
      data = ModelRazorPayResponse.fromJson(decodedResult);
      PaymentService().openCheckoutSession(data);
      return data;
    } catch (e) {
      log('$tag error: ${e.toString()}');
      return null;
    }
  }
}
