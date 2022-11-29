import 'package:formz/formz.dart';

enum PostTitleValidationError { invalid }

class PostTitle extends FormzInput<String, PostTitleValidationError> {
  const PostTitle.pure() : super.pure('');
  const PostTitle.dirty([String value = '']) : super.dirty(value);

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]',
  );

  @override
  PostTitleValidationError? validator(String? value) {
    return _emailRegExp.hasMatch(value ?? '')
        ? null
        : PostTitleValidationError.invalid;
  }
}
