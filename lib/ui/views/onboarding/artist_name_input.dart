import 'package:formz/formz.dart';

// Extend FormzInput and provide the input type and error type.
class ArtistNameInput extends FormzInput<String, ArtistNameInputError> {
  // Call super.pure to represent an unmodified form input.
  const ArtistNameInput.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const ArtistNameInput.dirty({String value = ''}) : super.dirty(value);

  // Override validator to handle validating a given input value.
  @override
  ArtistNameInputError? validator(String value) {
    return value.isEmpty ? ArtistNameInputError.empty : null;
  }
}

// Define input validation errors
enum ArtistNameInputError { empty }
