import 'package:formz/formz.dart';

enum BookingNoteValidationError { invalid }

class BookingNote
    extends FormzInput<String, BookingNoteValidationError> {
  const BookingNote.pure() : super.pure('');
  const BookingNote.dirty([super.value = '']) : super.dirty();

  @override
  BookingNoteValidationError? validator(String value) {
    return null;
  }
}
