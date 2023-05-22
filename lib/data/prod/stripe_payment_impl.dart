import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intheloopapp/data/payment_repository.dart';
import 'package:intheloopapp/domains/models/payment_user.dart';

final _functions = FirebaseFunctions.instance;
final _stripe = Stripe.instance;
final _analytics = FirebaseAnalytics.instance;

// const _publishableTestKey =
// 'pk_test_51MjqoRIdnJ3C1QPEjac68utViyu6vQcJfRfEyNesdoi9eKZP5hKnxbuyHCcSFVH8mBjYAxN0qyMdn2P8ZQb5OuZo00Bfy49Ebc';
const _publishableKey =
    'pk_live_51MjqoRIdnJ3C1QPEjW2tlrF663G7QXTjZN0de769CrMXhaGMjw8fxwKOOo0k72nYZcmNI211knjPHTxIDLlvqDx800rdRODGrz';

class StripePaymentImpl implements PaymentRepository {
  @override
  Future<void> initPayments() async {
    Stripe.publishableKey = _publishableKey;
    Stripe.merchantIdentifier = 'merchant.com.intheloopstudio';
    await _stripe.applySettings();
  }

  Future<PaymentIntentResponse> _createPaymentSheet({
    required String? payerCustomerId,
    required String payerEmail,
    required String payeeConnectedAccountId,
    required int amount,
  }) async {
    final callable = _functions.httpsCallable('createPaymentIntent');

    final results = await callable<Map<String, dynamic>>({
      'destination': payeeConnectedAccountId,
      'amount': amount,
      'customerId': payerCustomerId,
      'receiptEmail': payerEmail,
    });
    final data = results.data;

    final res = PaymentIntentResponse(
      paymentIntent: data['paymentIntent'] as String,
      ephemeralKey: data['ephemeralKey'] as String,
      customer: data['customer'] as String,
      publishableKey: data['publishableKey'] as String,
    );

    return res;
  }

  @override
  Future<PaymentIntentResponse> initPaymentSheet({
    required String? payerCustomerId,
    required String customerEmail,
    required String payeeConnectedAccountId,
    required int amount,
  }) async {
    await Future.wait([
      _analytics.logBeginCheckout(
        currency: 'USD',
        value: amount.toDouble(),
      ),
      _analytics.logEvent(
        name: 'init_payment_sheet',
        parameters: {
          'currency': 'USD',
          'value': amount.toDouble(),
        },
      ),
    ]);

    // 1. create payment intent on the server
    final intent = await _createPaymentSheet(
      payerCustomerId: payerCustomerId,
      payerEmail: customerEmail,
      payeeConnectedAccountId: payeeConnectedAccountId,
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

    return intent;
  }

  @override
  Future<void> presentPaymentSheet() async {
    await _stripe.presentPaymentSheet();
  }

  @override
  Future<void> confirmPaymentSheetPayment() async {
    await _stripe.confirmPaymentSheetPayment();
  }

  @override
  Future<ConnectedAccountResponse> createConnectedAccount({
    String? accountId,
  }) async {
    final callable = _functions.httpsCallable('createConnectedAccount');

    final results = await callable<Map<String, dynamic>>({
      'accountId': accountId ?? '',
    });
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
