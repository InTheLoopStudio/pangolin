import 'package:formz/formz.dart';

enum PostDescriptionValidationError { invalid }

class PostDescription
    extends FormzInput<String, PostDescriptionValidationError> {
  const PostDescription.pure() : super.pure('');
  const PostDescription.dirty([String value = '']) : super.dirty(value);

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]',
  );

  @override
  PostDescriptionValidationError? validator(String? value) {
    return (_emailRegExp.hasMatch(value ?? '') && (value ?? '').isNotEmpty)
        ? null
        : PostDescriptionValidationError.invalid;
  }
}
