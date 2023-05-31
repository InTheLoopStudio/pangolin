import 'package:formz/formz.dart';

// Extend FormzInput and provide the input type and error type.
class UsernameInput extends FormzInput<String, UsernameInputError> {
  // Call super.pure to represent an unmodified form input.
  const UsernameInput.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const UsernameInput.dirty({String value = ''}) : super.dirty(value);

  // Override validator to handle validating a given input value.
  @override
  UsernameInputError? validator(String value) {
    return value.isEmpty ? UsernameInputError.empty : null;
  }
}

// Define input validation errors
enum UsernameInputError { empty }

extension on UsernameInputError {
  String text() {
    return switch (this) {
      UsernameInputError.empty =>
        'Please ensure the email entered is valid',
    };
  }
}
