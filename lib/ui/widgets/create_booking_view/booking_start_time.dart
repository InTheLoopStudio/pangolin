import 'package:formz/formz.dart';

enum BookingStartTimeValidationError { invalid }

class BookingStartTime
    extends FormzInput<DateTime, BookingStartTimeValidationError> {
  BookingStartTime.pure() : super.pure(DateTime.now());
  const BookingStartTime.dirty(super.value) : super.dirty();

  @override
  BookingStartTimeValidationError? validator(DateTime value) {
    return null;
  }
}
