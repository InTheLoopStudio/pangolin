import 'package:formz/formz.dart';

class ServiceTitle extends FormzInput<String, ServiceTitleValidationError> {
  const ServiceTitle.pure() : super.pure('');
  const ServiceTitle.dirty([super.value = '']) : super.dirty();

  @override
  ServiceTitleValidationError? validator(String? value) {
    return (value ?? '').isNotEmpty
        ? null
        : ServiceTitleValidationError.invalid;
  }
}

enum ServiceTitleValidationError { invalid }
