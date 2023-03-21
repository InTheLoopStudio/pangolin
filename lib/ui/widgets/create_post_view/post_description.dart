import 'package:formz/formz.dart';

enum PostDescriptionValidationError { invalid }

class PostDescription
    extends FormzInput<String, PostDescriptionValidationError> {
  const PostDescription.pure() : super.pure('');
  const PostDescription.dirty([super.value = '']) : super.dirty();

  @override
  PostDescriptionValidationError? validator(String? value) {
    return (value ?? '').isNotEmpty
        ? null
        : PostDescriptionValidationError.invalid;
  }
}
