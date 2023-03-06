import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Username extends Equatable {
  Username(String input) {
    final username = input.trim().toLowerCase();
    this.username = username;
  }

  late final String username;

  @override
  List<Object> get props => [username];

  @override
  String toString() {
    return username;
  }
}
