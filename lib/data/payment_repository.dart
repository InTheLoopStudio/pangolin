import 'package:intheloopapp/domains/models/payment_user.dart';

abstract class PaymentRepository {
  Future<void> initPayments();
  Future<void> initPaymentSheet({
    required String payerId,
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
