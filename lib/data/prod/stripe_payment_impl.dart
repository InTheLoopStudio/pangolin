import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intheloopapp/data/payment_repository.dart';
import 'package:intheloopapp/domains/models/payment_user.dart';

final _functions = FirebaseFunctions.instance;
final _stripe = Stripe.instance;
// const _publishableTestKey =
// 'pk_test_51MjqoRIdnJ3C1QPEjac68utViyu6vQcJfRfEyNesdoi9eKZP5hKnxbuyHCcSFVH8mBjYAxN0qyMdn2P8ZQb5OuZo00Bfy49Ebc';

class StripePaymentImpl implements PaymentRepository {
  Future<PaymentIntentResponse> _createTestPaymentSheet({
    required String payerId,
    required String payeeId,
    required int amount,
  }) async {
    final callable = _functions.httpsCallable('createPaymentIntent');

    final results = await callable<Map<String, String>>();
    final data = results.data;
    print('RES $data');

    final res = PaymentIntentResponse(
      paymentIntent: data['paymentIntent'] ?? '',
      ephemeralKey: data['ephemeralKey'] ?? '',
      customer: data['customer'] ?? '',
      publishableKey: data['publishableKey'] ?? '',
    );

    return res;
  }

  @override
  Future<void> initPaymentSheet({
    required String payerId,
    required String payeeId,
    required int amount,
  }) async {
    // 1. create payment intent on the server
    final intent = await _createTestPaymentSheet(
      payerId: payerId,
      payeeId: payeeId,
      amount: amount,
    );

    // 2. initialize the payment sheet
    await _stripe.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        // Enable custom flow
        customFlow: true,
        // Main params
        merchantDisplayName: 'Tapped',
        paymentIntentClientSecret: intent.paymentIntent,
        // Customer keys
        customerEphemeralKeySecret: intent.ephemeralKey,
        customerId: intent.customer,
        applePay: const PaymentSheetApplePay(merchantCountryCode: 'US'),
        googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'US'),
      ),
    );
  }

  @override
  Future<void> presentPaymentSheet() async {
    await _stripe.presentPaymentSheet();
  }

  @override
  Future<ConnectedAccountResponse> createConnectedAccount() async {
    final callable = _functions.httpsCallable('createConnectedAccount');

    final results = await callable<Map<String, dynamic>>();
    final data = results.data;

    final res = ConnectedAccountResponse(
      success: (data['success'] as bool?) ?? false,
      accountId: (data['accountId'] as String?) ?? '',
      url: (data['url'] as String?) ?? '',
    );

    return res;
  }

  @override
  Future<PaymentUser?> getAccountById(String id) async {
    final callable = _functions.httpsCallable('getAccountById');
    final results = await callable<Map<String, dynamic>>({
      'accountId': id,
    });
    final data = results.data;

    final paymentUser = PaymentUser.fromJson(data);

    return paymentUser;
  }
}

class PaymentIntentResponse {
  PaymentIntentResponse({
    required this.paymentIntent,
    required this.ephemeralKey,
    required this.customer,
    required this.publishableKey,
  });

  final String paymentIntent;
  final String ephemeralKey;
  final String customer;
  final String publishableKey;
}
