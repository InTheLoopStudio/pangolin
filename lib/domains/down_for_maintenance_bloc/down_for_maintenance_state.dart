part of 'down_for_maintenance_bloc.dart';

class DownForMaintenanceState extends Equatable {
  const DownForMaintenanceState({this.downForMaintenance = false});

  final bool downForMaintenance;

  @override
  List<Object> get props => [downForMaintenance];
}
