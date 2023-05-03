part of 'create_service_cubit.dart';

class CreateServiceState extends Equatable with FormzMixin  {
  const CreateServiceState({
    this.title = const ServiceTitle.pure(),
    this.description = const ServiceDescription.pure(),
    this.rate = 0,
    this.rateType = RateType.hourly,
    this.status = FormzSubmissionStatus.initial,
  });

  final ServiceTitle title;
  final ServiceDescription description;
  final int rate;
  final RateType rateType;

  final FormzSubmissionStatus status;

  @override
  List<Object> get props => [
        title,
        description,
        rate,
        rateType,
        status,
  ];

  CreateServiceState copyWith({
    ServiceTitle? title,
    ServiceDescription? description,
    int? rate,
    RateType? rateType,
    FormzSubmissionStatus? status,
  }) {
    return CreateServiceState(
      title: title ?? this.title,
      description: description ?? this.description,
      rate: rate ?? this.rate,
      rateType: rateType ?? this.rateType,
      status: status ?? this.status,
    );
  }
  
  @override
  List<FormzInput> get inputs => [
    title,
    description,
  ];
}
