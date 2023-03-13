import 'package:formz/formz.dart';

enum BookingEndTimeValidationError { invalid }

class BookingEndTime
    extends FormzInput<DateTime, BookingEndTimeValidationError> {
  BookingEndTime.pure() : super.pure(DateTime.now());
  const BookingEndTime.dirty(DateTime value) : super.dirty(value);

  @override
  BookingEndTimeValidationError? validator(DateTime value) {
    return null;
  }
}
