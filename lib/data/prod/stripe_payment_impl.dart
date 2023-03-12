import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intheloopapp/data/payment_repository.dart';

final _stripe = Stripe.instance;
const _publishableTestKey =
    'pk_test_51MjqoRIdnJ3C1QPEjac68utViyu6vQcJfRfEyNesdoi9eKZP5hKnxbuyHCcSFVH8mBjYAxN0qyMdn2P8ZQb5OuZo00Bfy49Ebc';

class StripePaymentImpl implements PaymentRepository {
  @override
  Future<void> configure3dSecure() {
    // TODO: implement configure3dSecure
    throw UnimplementedError();
  }

  @override
  Future<void> confirmApplePayPayment() {
    // TODO: implement confirmApplePayPayment
    throw UnimplementedError();
  }

  @override
  Future<PaymentIntent> confirmPayment() {
    // TODO: implement confirmPayment
    throw UnimplementedError();
  }

  @override
  Future<void> confirmPaymentSheetPayment() {
    // TODO: implement confirmPaymentSheetPayment
    throw UnimplementedError();
  }

  @override
  Future<PaymentMethod> createPaymentMethod() {
    // TODO: implement createPaymentMethod
    throw UnimplementedError();
  }

  @override
  Future<String> createTokenForCVCUpdate() {
    // TODO: implement createTokenForCVCUpdate
    throw UnimplementedError();
  }

  @override
  Future<PaymentIntent> handleNextAction() {
    // TODO: implement handleNextAction
    throw UnimplementedError();
  }

  @override
  Future<void> initPaymentSheet() {
    // TODO: implement initPaymentSheet
    throw UnimplementedError();
  }

  @override
  Future<bool> isApplePaySupported() {
    // TODO: implement isApplePaySupported
    throw UnimplementedError();
  }

  @override
  Future<void> presentApplePay() {
    // TODO: implement presentApplePay
    throw UnimplementedError();
  }

  @override
  Future<void> presentPaymentSheet() {
    // TODO: implement presentPaymentSheet
    throw UnimplementedError();
  }

  @override
  Future<PaymentIntent> retrievePaymentIntent() {
    // TODO: implement retrievePaymentIntent
    throw UnimplementedError();
  }

  @override
  Future<SetupIntent> confirmSetupIntent() {
    // TODO: implement confirmSetupIntent
    throw UnimplementedError();
  }
}
