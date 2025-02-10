import 'package:flutter/material.dart';

// import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:medimed/Screens/section4_payment/page1.dart';

class PaymentPage3 extends StatelessWidget {
  final String cardNumber; // Example
  final String expiryDate; // Example
  final String cardHolderName; // Example
  final String cvvCode; // Example
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> cardNumberKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> cvvCodeKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> expiryDateKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> cardHolderKey =
      GlobalKey<FormFieldState<String>>();

  PaymentPage3({
    super.key,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Card",
          style: TextStyle(color: Color(0xff0299c6)),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 50, 19, 0),
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage1(

                        ),
                      ));
                },
                color: const Color(0xff0299c6),
                child: const Text("Save Card"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
