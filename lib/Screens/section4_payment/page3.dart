import 'package:flutter/material.dart';
import 'package:medimed/Screens/section4_payment/page4.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class PaymentPage3 extends StatefulWidget {
  const PaymentPage3({super.key});

  @override
  State<PaymentPage3> createState() => _PaymentPage3State();
}

class _PaymentPage3State extends State<PaymentPage3> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ✅ Declare missing keys
  final GlobalKey<FormFieldState<String>> cardNumberKey =
  GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> cvvCodeKey =
  GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> expiryDateKey =
  GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> cardHolderKey =
  GlobalKey<FormFieldState<String>>();

  // ✅ Credit card details variables
  String cardNumber = "";
  String expiryDate = "";
  String cardHolderName = "";
  String cvvCode = "";

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
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: false,
              onCreditCardWidgetChange: (CreditCardBrand brand) {},
              bankName: 'Name of the Bank',
              cardBgColor: Colors.yellow,
              glassmorphismConfig: Glassmorphism(
                blurX: 10.0,
                blurY: 10.0,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Colors.grey.withAlpha(20),
                    Colors.white.withAlpha(20),
                  ],
                  stops: const <double>[0.3, 0],
                ),
              ),
              enableFloatingCard: true,
              floatingConfig: const FloatingConfig(
                isGlareEnabled: true,
                isShadowEnabled: true,
                shadowConfig: FloatingShadowConfig(
                  offset: Offset(10, 10),
                  color: Colors.blue,
                  blurRadius: 15,
                ),
              ),
              backgroundNetworkImage: 'https://www.xyz.com/card_bg.png',
              labelValidThru: 'VALID\nTHRU',
              obscureCardNumber: true,
              obscureInitialCardNumber: false,
              obscureCardCvv: true,
              labelCardHolder: 'CARD HOLDER',
              cardType: CardType.mastercard,
              isHolderNameVisible: true, // ✅ Ensure cardholder name is visible
              height: 175,
              textStyle: const TextStyle(color: Colors.black87),
              width: MediaQuery.of(context).size.width,
              isChipVisible: true,
              isSwipeGestureEnabled: true,
              animationDuration: const Duration(milliseconds: 1000),
              frontCardBorder: Border.all(color: Colors.black87),
              backCardBorder: Border.all(color: Colors.black87),
              chipColor: Colors.yellow[100],
              padding: 16,
            ),
            CreditCardForm(
              formKey: formKey, // ✅ Required
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              cardNumberKey: cardNumberKey,
              cvvCodeKey: cvvCodeKey,
              expiryDateKey: expiryDateKey,
              cardHolderKey: cardHolderKey,

              // ✅ Update credit card details dynamically
              onCreditCardModelChange: (CreditCardModel data) {
                setState(() {
                  cardNumber = data.cardNumber;
                  expiryDate = data.expiryDate;
                  cardHolderName = data.cardHolderName;
                  cvvCode = data.cvvCode;
                });
              },

              obscureCvv: true,
              obscureNumber: true,
              isHolderNameVisible: true,
              isCardNumberVisible: true,
              isExpiryDateVisible: true,
              enableCvv: true,
              cvvValidationMessage: 'Please input a valid CVV',
              dateValidationMessage: 'Please input a valid date',
              numberValidationMessage: 'Please input a valid number',

              // ✅ Validation functions
              cardNumberValidator: (String? cardNumber) {
                if (cardNumber == null || cardNumber.length < 16) {
                  return 'Invalid card number';
                }
                return null;
              },
              expiryDateValidator: (String? expiryDate) {
                if (expiryDate == null || expiryDate.length != 5) {
                  return 'Invalid expiry date';
                }
                return null;
              },
              cvvValidator: (String? cvv) {
                if (cvv == null || cvv.length < 3) {
                  return 'Invalid CVV';
                }
                return null;
              },
              cardHolderValidator: (String? cardHolderName) {
                if (cardHolderName == null || cardHolderName.isEmpty) {
                  return 'Enter cardholder name';
                }
                return null;
              },

              onFormComplete: () {
                // ✅ Callback for when the form is completely filled
                if (formKey.currentState!.validate()) {
                  debugPrint("Form is valid!");
                }
              },
              autovalidateMode: AutovalidateMode.always,
              disableCardNumberAutoFillHints: false,
              inputConfiguration: const InputConfiguration(
                cardNumberDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Number',
                  hintText: 'XXXX XXXX XXXX XXXX',
                ),
                expiryDateDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Expired Date',
                  hintText: 'XX/XX',
                ),
                cvvCodeDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'CVV',
                  hintText: 'XXX',
                ),
                cardHolderDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Card Holder',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 50, 19, 0),
              child: MaterialButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage4(),
                      ),
                    );
                  }
                },
                color: const Color(0xff0299c6),
                child: const Text("Save Card"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}