import 'package:intheloopapp/domains/models/payment_user.dart';

abstract class PaymentRepository {
  Future<void> initPayments();
  Future<PaymentIntentResponse> initPaymentSheet({
    required String payerCustomerId,
    required String payeeConnectedAccountId,
    required int amount,
  });
  Future<void> presentPaymentSheet();
  Future<void> confirmPaymentSheetPayment();
  Future<ConnectedAccountResponse> createConnectedAccount({
    String accountId,
  });

  Future<PaymentUser?> getAccountById(String id);
}

class ConnectedAccountResponse {
  ConnectedAccountResponse({
    required this.success,
    required this.accountId,
    required this.url,
  });

  final bool success;
  final String accountId;
  final String url;
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
