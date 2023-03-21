import 'package:formz/formz.dart';

enum BookingEndTimeValidationError { invalid }

class BookingEndTime
    extends FormzInput<DateTime, BookingEndTimeValidationError> {
  BookingEndTime.pure() : super.pure(DateTime.now());
  const BookingEndTime.dirty(super.value) : super.dirty();

  @override
  BookingEndTimeValidationError? validator(DateTime value) {
    return null;
  }
}
