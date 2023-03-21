import 'package:formz/formz.dart';

enum PostTitleValidationError { invalid }

class PostTitle extends FormzInput<String, PostTitleValidationError> {
  const PostTitle.pure() : super.pure('');
  const PostTitle.dirty([super.value = '']) : super.dirty();

  @override
  PostTitleValidationError? validator(String? value) {
    return null;
  }
}
