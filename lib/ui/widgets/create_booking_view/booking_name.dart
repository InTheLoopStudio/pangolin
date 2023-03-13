import 'package:formz/formz.dart';

enum BookingNameValidationError { invalid }

class BookingName
    extends FormzInput<String, BookingNameValidationError> {
  const BookingName.pure() : super.pure('');
  const BookingName.dirty([String value = '']) : super.dirty(value);

  @override
  BookingNameValidationError? validator(String value) {
    return null;
  }
}
