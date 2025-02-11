import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:payment_getway_integration/apis/rest_razorpay_service.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentService {
  final Razorpay razorpay = Razorpay();
  final razorPayKey = dotenv.get("KEY_ID");
  final razorPaySecret = dotenv.get("KEY_SECRET");

  initiateRazorPay() {
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse pmtSuccessResponse) {
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse pmtFailureResponse) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse pmtExternalWalletResponse) {
    // Do something when an external wallet is selected
  }

  openSession({required num amount}) {
    createOrder(amount: amount).then((orderId) {
      log(orderId.toString());
      if (orderId.toString().isNotEmpty) {
        var options = {
          'key': razorPayKey, //Razor pay API Key
          'amount': amount, //in the smallest currency sub-unit.
          'name': 'AKS & Co.',
          'order_id': orderId, // Generate order_id using Orders API
          'description': 'Thank you for shopping with us!', //Order Description to be shown in razor pay page
          'timeout': 120, // in seconds
          'prefill': {'contact': '6353508065', 'email': 'avadh@yopmail.com'}, //contact number and email id of user
          'method': {
            'netbanking': false,
            'card': true,
            'upi': true,
            'wallet': false,
            'paylater': false,
          },
        };
        razorpay.open(options);
      } else {
        log("Could not find orderId.");
      }
    });
  }

  createOrder({
    required num amount,
  }) async {
    final myData = await RESTRazorpayService().razorPayApi(amount, "rcp_id_1");
    log(myData.toString());
    if (myData!["status"] == "success") {
      log(myData.toString());
      return myData["body"]["id"];
    } else {
      return "";
    }
  }
}
