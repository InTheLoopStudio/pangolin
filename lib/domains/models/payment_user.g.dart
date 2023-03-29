// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentUser _$PaymentUserFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'charges_enabled',
      'payouts_enabled',
      'country',
      'created',
      'default_currency',
      'details_submitted'
    ],
  );
  return PaymentUser(
    id: json['id'] as String,
    chargesEnabled: json['charges_enabled'] as bool,
    payoutsEnabled: json['payouts_enabled'] as bool,
    country: json['country'] as String,
    createdAt: dateTimeFromInt(json['created'] as int?),
    defaultCurrency: json['default_currency'] as String,
    detailsSubmitted: json['details_submitted'] as bool,
  );
}

Map<String, dynamic> _$PaymentUserToJson(PaymentUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'charges_enabled': instance.chargesEnabled,
      'payouts_enabled': instance.payoutsEnabled,
      'country': instance.country,
      'created': instance.createdAt.toIso8601String(),
      'default_currency': instance.defaultCurrency,
      'details_submitted': instance.detailsSubmitted,
    };
