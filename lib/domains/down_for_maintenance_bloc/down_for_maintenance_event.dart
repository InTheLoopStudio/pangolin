part of 'down_for_maintenance_bloc.dart';

abstract class DownForMaintenanceEvent extends Equatable {
  const DownForMaintenanceEvent();
}

class CheckStatus implements DownForMaintenanceEvent {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}
