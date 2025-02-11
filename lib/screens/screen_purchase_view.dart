import 'package:flutter/material.dart';
import 'package:payment_getway_integration/apis/rest_razorpay_service.dart';
import 'package:payment_getway_integration/razorpay/razorpay_helper.dart';

class ScreenPurchaseView extends StatefulWidget {
  const ScreenPurchaseView({super.key});

  @override
  State<ScreenPurchaseView> createState() => _ScreenPurchaseViewState();
}

class _ScreenPurchaseViewState extends State<ScreenPurchaseView> {
  final PaymentService paymentService = PaymentService();

  @override
  void dispose() {
    paymentService.disposeRazorPayInstance();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent.shade100,
        foregroundColor: Colors.white,
        title: const Text("RazorPay Integration"),
      ),
      body: const SafeArea(
          child: Center(
        child: Text(
          "Pay with Razorpay",
          style: TextStyle(fontSize: 18),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          RESTRazorpayService().createOrder(11, "rcp_id_1").then(
            (value) {
              paymentService.initiateRazorPay();
            },
          );
        },
        tooltip: "Pay",
        child: const Icon(Icons.paypal),
      ),
    );
  }
}
