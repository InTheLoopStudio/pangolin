import 'package:formz/formz.dart';

enum BookingNameValidationError { invalid }

class BookingName
    extends FormzInput<String, BookingNameValidationError> {
  const BookingName.pure() : super.pure('');
  const BookingName.dirty([super.value = '']) : super.dirty();

  @override
  BookingNameValidationError? validator(String value) {
    return null;
  }
}
