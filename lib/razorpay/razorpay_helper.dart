import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:payment_getway_integration/models/model_razorpay_response.dart';
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
    log("Payment success: ${pmtSuccessResponse.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse pmtFailureResponse) {
    log("Payment failure: ${jsonDecode(pmtFailureResponse.message!)['error']['description']}");
  }

  void _handleExternalWallet(ExternalWalletResponse pmtExternalWalletResponse) {
    log("External wallet: ${pmtExternalWalletResponse.walletName}");
  }

  openCheckoutSession(ModelRazorPayResponse resData) {
    var options = {
      'key': razorPayKey, //Razor pay API Key
      'amount': resData.amount, //in the smallest currency sub-unit.
      'name': 'AKS & Co.',
      'order_id': resData.id, // Generate order_id using Orders API
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
    try {
      razorpay.open(options);
    } catch (e) {
      log('Checkout Session Error: ${e.toString()}');
    }
  }

  disposeRazorPayInstance() {
    razorpay.clear();
  }
}
