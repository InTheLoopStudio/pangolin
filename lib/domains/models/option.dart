import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

/// Represents an optional value of type [T].
///
/// An [Option] is either:
/// - [Some], which contains a value of type [T]
/// - [None], which does not contain a value
///
/// Adapted from Rust's `Option`, see more here:
/// https://doc.rust-lang.org/std/option/index.html
@immutable
sealed class Option<T> {
  /// Base constructor for [Option]s.
  const Option();

  /// Shortcut for [Some.new].
  const factory Option.some(T value) = Some;

  /// Shortcut for [None.new].
  const factory Option.none() = None;

  factory Option.fromNullable(T? value) {
    return value == null ? const Option.none() : Option.some(value);
  }

  static Object? toJson(Option<dynamic> option) => option.asNullable();
  static Option<dynamic> fromJson(dynamic value) => Option.fromNullable(value);
}

/// An [Option] that has a [value].
@immutable
final class Some<T> extends Option<T> {
  /// Creates an [Option] with the associated immutable [value].
  const Some(this.value);

  /// The immutable [value] associated with this [Option].
  final T value;

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) => other is Some<T> && other.value == value;

  @override
  String toString() => 'Some(value: $value)';
}

/// An [Option] that does not have a value.
@immutable
final class None<T> extends Option<T> {
  /// Creates an [Option] that does not have a value.
  const None();

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) => other is None<T>;

  @override
  String toString() => 'None()';
}

/// Convenience methods for handling [Option]s.
extension OptionConvenience<T> on Option<T> {
  bool get isSome => this is Some<T>;

  bool get isNone => this is None<T>;

  /// Returns [Some.value] if `this` is a [Some].
  /// Otherwise, throws [StateError] (when [None]).
  T get unwrap {
    return switch (this) {
      Some(:final value) => value,
      None() => throw StateError('Cannot unwrap a None'),
    };
  }

  /// Returns [Some.value] if `this` is a [Some].
  /// Otherwise, returns [defaultValue] (when [None]).
  T unwrapOr(T defaultValue) {
    return switch (this) {
      Some(:final value) => value,
      None() => defaultValue,
    };
  }

  /// Returns [Some.value] if `this` is a [Some].
  /// Otherwise, calls and returns the result of [defaultFn] (when [None]).
  T unwrapOrElse(T Function() defaultFn) {
    return switch (this) {
      Some(:final value) => value,
      None() => defaultFn(),
    };
  }

  Option<R> map<R>(R Function(T) f) =>
      isSome ? Option.some(f(unwrap)) : const Option.none();

  Option<R> flatMap<R>(Option<R> Function(T) f) =>
      isSome ? f(unwrap) : const Option.none();

  Option<T> filter(bool Function(T) f) =>
      isSome && f(unwrap) ? this : const Option.none();

  Option<T> or(Option<T> other) => isSome ? this : other;

  Option<T> orElse(Option<T> Function() f) => isSome ? this : f();

  Option<T> and(Option<T> other) =>
      isSome && other.isSome ? this : const Option.none();

  Option<T> andThen(Option<T> Function() f) =>
      isSome ? f() : const Option.none();

  Option<T> xor(Option<T> other) =>
      isSome ^ other.isSome ? this : const Option.none();

  Option<T> not() => isSome ? const Option.none() : this;

  /// Returns [Some.value] or `null` for [None].
  T? asNullable() {
    return switch (this) {
      Some(:final value) => value,
      None() => null,
    };
  }
}

class OptionalStringConverter
    implements JsonConverter<Option<String>, String?> {
  const OptionalStringConverter();

  @override
  Option<String> fromJson(String? value) => Option.fromNullable(value);

  @override
  String? toJson(Option<String> option) => option.asNullable();
}
