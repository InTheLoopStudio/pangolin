part of 'create_service_cubit.dart';

class CreateServiceState extends Equatable {
  const CreateServiceState({
    this.title = '',
    this.description = '',
    this.rate = 0,
    this.rateType = RateType.hourly,
    this.loading = false,
  });

  final String title;
  final String description;
  final int rate;
  final RateType rateType;

  final bool loading;

  @override
  List<Object> get props => [
        title,
        description,
        rate,
        rateType,
        loading,
  ];

  CreateServiceState copyWith({
    String? title,
    String? description,
    int? rate,
    RateType? rateType,
    bool? loading,
  }) {
    return CreateServiceState(
      title: title ?? this.title,
      description: description ?? this.description,
      rate: rate ?? this.rate,
      rateType: rateType ?? this.rateType,
      loading: loading ?? this.loading,
    );
  }
}
