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
  TextEditingController tcPmtAmount = TextEditingController();

  @override
  void initState() {
    super.initState();
    paymentService.initiateRazorPay();
  }

  @override
  void dispose() {
    tcPmtAmount.dispose();
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
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Pay with Razorpay",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: tcPmtAmount,
              keyboardType: TextInputType.number,
              maxLength: 10,
              maxLines: 1,
              decoration: const InputDecoration(hintText: "Amount", counterText: ""),
            ),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (tcPmtAmount.text.isNotEmpty && tcPmtAmount.text != "") {
            await RESTRazorpayService().createOrder(int.parse(tcPmtAmount.text), "rcp_id_1").then(
              (value) {
                tcPmtAmount.clear();
              },
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid input")));
          }
        },
        tooltip: "Pay",
        child: const Icon(Icons.paypal),
      ),
    );
  }
}
