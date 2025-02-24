import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:medimed/Payment%20Method/stripe_keys.dart';

abstract class PaymentManager{

  static Future<bool>makePayment(int amount,String currency)async{
    try {
      String clientSecret=await _getClientSecret((amount*100).toString(), currency);
      await _initializePaymentSheet(clientSecret);
      await Stripe.instance.presentPaymentSheet();
      return true;
    } catch (error) {
      throw Exception(error.toString());
      return false;
    }
  }

  static Future<void>_initializePaymentSheet(String clientSecret)async{
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: "MediMed",
      ),
    );
  }

  static Future<String> _getClientSecret(String amount, String currency) async {
    Dio dio = Dio();

    // Ensure amount is an integer and respects Stripe's minimum limit
    int finalAmount = int.parse(amount) * 100; // Convert EGP to piastres

    if (finalAmount < 5000) { // ~ 50 cents (USD equivalent)
      throw Exception("Minimum payment amount must be at least 50 EGP.");
    }

    try {
      var response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${ApiKeys.secretKey}',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
        ),
        data: {
          'amount': finalAmount,
          'currency': currency.toLowerCase(),
          'payment_method_types[]': 'card',
        },
      );

      print("🟢 Stripe Response: ${response.data}");
      return response.data["client_secret"];
    } on DioException catch (e) {
      print("🔴 Stripe API Error: ${e.response?.data}");
      throw Exception("Stripe API error: ${e.response?.data}");
    }
  }



}