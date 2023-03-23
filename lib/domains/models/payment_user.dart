import 'package:json_annotation/json_annotation.dart';

part 'payment_user.g.dart';

@JsonSerializable()
class PaymentUser {
  PaymentUser({
    required this.id,
    required this.chargesEnabled,
    required this.payoutsEnabled,
    required this.country,
    required this.createdAt,
    required this.defaultCurrency,
    required this.detailsSubmitted,
  });

  factory PaymentUser.fromJson(Map<String, dynamic> json) {
    return _$PaymentUserFromJson(json);
  }

  @JsonKey(required: true)
  final String id;

  @JsonKey(required: true, name: 'charges_enabled')
  final bool chargesEnabled;

  @JsonKey(required: true, name: 'payouts_enabled')
  final bool payoutsEnabled;

  @JsonKey(required: true)
  final String country;

  @JsonKey(required: true, name: 'created')
  final DateTime createdAt;

  @JsonKey(required: true, name: 'default_currency')
  final String defaultCurrency;

  @JsonKey(required: true, name: 'details_submitted')
  final bool detailsSubmitted;


  Map<String, dynamic> toJson() => _$PaymentUserToJson(this);
}
