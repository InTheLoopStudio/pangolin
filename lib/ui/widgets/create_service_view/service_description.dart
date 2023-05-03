import 'package:formz/formz.dart';

class ServiceDescription
    extends FormzInput<String, ServiceDescriptionValidationError> {
  const ServiceDescription.pure() : super.pure('');
  const ServiceDescription.dirty([super.value = '']) : super.dirty();

  @override
  ServiceDescriptionValidationError? validator(String? value) {
    return (value ?? '').isNotEmpty
        ? null
        : ServiceDescriptionValidationError.invalid;
  }
}

enum ServiceDescriptionValidationError { invalid }
