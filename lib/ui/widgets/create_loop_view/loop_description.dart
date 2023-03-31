import 'package:formz/formz.dart';

enum LoopDescriptionValidationError { invalid }

class LoopDescription
    extends FormzInput<String, LoopDescriptionValidationError> {
  const LoopDescription.pure() : super.pure('');
  const LoopDescription.dirty([super.value = '']) : super.dirty();

  @override
  LoopDescriptionValidationError? validator(String? value) {
    return (value ?? '').isNotEmpty
        ? null
        : LoopDescriptionValidationError.invalid;
  }
}
