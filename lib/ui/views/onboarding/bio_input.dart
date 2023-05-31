import 'package:formz/formz.dart';

// Extend FormzInput and provide the input type and error type.
class BioInput extends FormzInput<String, BioInputError> {
  // Call super.pure to represent an unmodified form input.
  const BioInput.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const BioInput.dirty({String value = ''}) : super.dirty(value);

  // Override validator to handle validating a given input value.
  @override
  BioInputError? validator(String value) {
    return value.isEmpty ? BioInputError.empty : null;
  }
}

// Define input validation errors
enum BioInputError { empty }
