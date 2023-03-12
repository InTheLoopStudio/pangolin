
import 'package:flutter_stripe/flutter_stripe.dart';

abstract class PaymentRepository {
  Future<PaymentMethod> createPaymentMethod();
  Future<PaymentIntent> handleNextAction();
  Future<PaymentIntent> confirmPayment();
  Future<void> configure3dSecure();
  Future<bool> isApplePaySupported();
  Future<void> presentApplePay();
  Future<void> confirmApplePayPayment();
  Future<SetupIntent> confirmSetupIntent();
  Future<PaymentIntent> retrievePaymentIntent();
  Future<String> createTokenForCVCUpdate();

  Future<void> initPaymentSheet();
  Future<void> presentPaymentSheet();
  Future<void> confirmPaymentSheetPayment();
}
