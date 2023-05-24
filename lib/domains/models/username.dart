import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'username.g.dart';

@JsonSerializable(constructor: '_')
class Username extends Equatable {
  // dart trick to create private constructor
  const Username._(this.username);

  factory Username.fromString(String input) {
    final username = input.trim().toLowerCase();
    return Username._(username);
  }

  factory Username.fromJson(Map<String, dynamic> json) =>
      _$UsernameFromJson(json);

  final String username;

  @override
  List<Object> get props => [username];

  Map<String, dynamic> toJson() => _$UsernameToJson(this);

  @override
  String toString() {
    return username;
  }

  static String usernameToString(Username? username) {
    return username?.username ?? '';
  }
}
