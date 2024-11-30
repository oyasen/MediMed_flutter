import 'package:flutter/material.dart';

// import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:medimed/Screens/section4_payment/page4.dart';

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
            // CreditCardWidget(
            //   cardNumber: cardNumber,
            //   expiryDate: expiryDate,
            //   cardHolderName: cardHolderName,
            //   cvvCode: cvvCode,
            //   showBackView: false,
            //   onCreditCardWidgetChange: (CreditCardBrand brand) {},
            //   bankName: 'Name of the Bank',
            //   cardBgColor: Colors.black87,
            //   glassmorphismConfig: Glassmorphism(
            //     blurX: 10.0,
            //     blurY: 10.0,
            //     gradient: LinearGradient(
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomRight,
            //       colors: <Color>[
            //         Colors.grey.withAlpha(20),
            //         Colors.white.withAlpha(20),
            //       ],
            //       stops: const <double>[
            //         0.3,
            //         0,
            //       ],
            //     ),
            //   ),
            //   enableFloatingCard: true,
            //   floatingConfig: const FloatingConfig(
            //     isGlareEnabled: true,
            //     isShadowEnabled: true,
            //     shadowConfig: FloatingShadowConfig(
            //       offset: Offset(10, 10),
            //       color: Color(0xff0299c6),
            //       blurRadius: 15,
            //     ),
            //   ),
            //   backgroundNetworkImage: 'https://www.xyz.com/card_bg.png',
            //   labelValidThru: 'VALID\nTHRU',
            //   obscureCardNumber: true,
            //   obscureInitialCardNumber: false,
            //   obscureCardCvv: true,
            //   labelCardHolder: 'CARD HOLDER',
            //   cardType: CardType.mastercard,
            //   isHolderNameVisible: false,
            //   height: 175,
            //   textStyle: const TextStyle(color: Colors.black87),
            //   width: MediaQuery.of(context).size.width,
            //   isChipVisible: true,
            //   isSwipeGestureEnabled: true,
            //   animationDuration: const Duration(milliseconds: 1000),
            //   frontCardBorder: Border.all(color: Colors.grey),
            //   backCardBorder: Border.all(color: Colors.grey),
            //   chipColor: Colors.black87,
            //   padding: 16,
            // ),
            // CreditCardForm(
            //   formKey: formKey,
            //   // Required
            //   cardNumber: cardNumber,
            //   // Required
            //   expiryDate: expiryDate,
            //   // Required
            //   cardHolderName: cardHolderName,
            //   // Required
            //   cvvCode: cvvCode,
            //   // Required
            //   cardNumberKey: cardNumberKey,
            //   cvvCodeKey: cvvCodeKey,
            //   expiryDateKey: expiryDateKey,
            //   cardHolderKey: cardHolderKey,
            //   onCreditCardModelChange: (CreditCardModel data) {},
            //   // Required
            //   obscureCvv: true,
            //   obscureNumber: true,
            //   isHolderNameVisible: true,
            //   isCardNumberVisible: true,
            //   isExpiryDateVisible: true,
            //   enableCvv: true,
            //   cvvValidationMessage: 'Please input a valid CVV',
            //   dateValidationMessage: 'Please input a valid date',
            //   numberValidationMessage: 'Please input a valid number',
            //   cardNumberValidator: (String? cardNumber) {},
            //   expiryDateValidator: (String? expiryDate) {},
            //   cvvValidator: (String? cvv) {},
            //   cardHolderValidator: (String? cardHolderName) {},
            //   onFormComplete: () {
            //     // callback to execute at the end of filling card data
            //   },
            //   autovalidateMode: AutovalidateMode.always,
            //   disableCardNumberAutoFillHints: false,
            //   inputConfiguration: const InputConfiguration(
            //     cardNumberDecoration: InputDecoration(
            //       border: OutlineInputBorder(),
            //       labelText: 'Number',
            //       hintText: 'XXXX XXXX XXXX XXXX',
            //     ),
            //     expiryDateDecoration: InputDecoration(
            //       border: OutlineInputBorder(),
            //       labelText: 'Expired Date',
            //       hintText: 'XX/XX',
            //     ),
            //     cvvCodeDecoration: InputDecoration(
            //       border: OutlineInputBorder(),
            //       labelText: 'CVV',
            //       hintText: 'XXX',
            //     ),
            //     cardHolderDecoration: InputDecoration(
            //       border: OutlineInputBorder(),
            //       labelText: 'Card Holder',
            //     ),
            //     cardNumberTextStyle: TextStyle(
            //       fontSize: 10,
            //       color: Colors.black,
            //     ),
            //     cardHolderTextStyle: TextStyle(
            //       fontSize: 10,
            //       color: Colors.black,
            //     ),
            //     expiryDateTextStyle: TextStyle(
            //       fontSize: 10,
            //       color: Colors.black,
            //     ),
            //     cvvCodeTextStyle: TextStyle(
            //       fontSize: 10,
            //       color: Colors.black,
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 50, 19, 0),
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage4(),
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
