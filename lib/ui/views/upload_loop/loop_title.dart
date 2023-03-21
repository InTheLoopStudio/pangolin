import 'package:formz/formz.dart';

enum LoopTitleValidationError { invalid }

class LoopTitle extends FormzInput<String, LoopTitleValidationError> {
  const LoopTitle.pure() : super.pure('');
  const LoopTitle.dirty([super.value = '']) : super.dirty();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]',
  );

  @override
  LoopTitleValidationError? validator(String? value) {
    return (_emailRegExp.hasMatch(value ?? '') && (value ?? '').isNotEmpty)
        ? null
        : LoopTitleValidationError.invalid;
  }
}
