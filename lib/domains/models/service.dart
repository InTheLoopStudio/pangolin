import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/utils.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'service.g.dart';

@JsonSerializable()
class Service extends Equatable {
  const Service({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.rate,
    required this.rateType,
    required this.count,
    required this.deleted,
  });

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);

  factory Service.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Service(
      id: doc.id,
      userId: doc.getOrElse('userId', '') as String,
      title: doc.getOrElse('title', '') as String,
      description: doc.getOrElse('description', '') as String,
      rate: doc.getOrElse('rate', 0) as int,
      rateType: EnumToString.fromString(
            RateType.values,
            doc.getOrElse('rateType', '') as String,
          ) ??
          RateType.hourly,
      count: doc.getOrElse('count', 0) as int,
      deleted: doc.getOrElse('deleted', false) as bool,
    );
  }

  factory Service.empty() => Service(
        id: const Uuid().v4(),
        userId: '',
        title: '',
        description: '',
        rate: 0,
        rateType: RateType.hourly,
        count: 0,
        deleted: false,
      );

  final String id;
  final String userId;
  final String title;
  final String description;
  final int rate;
  final RateType rateType;
  final int count;
  final bool deleted;

  Map<String, dynamic> toJson() => _$ServiceToJson(this);

  @override
  List<Object> get props => [
        id,
        userId,
        title,
        description,
        rate,
        rateType,
        count,
        deleted,
      ];
}

enum RateType {
  @JsonValue('hourly')
  hourly,

  @JsonValue('fixed')
  fixed,
}
