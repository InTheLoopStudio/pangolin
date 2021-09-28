import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/data/remote_config_repository.dart';

part 'down_for_maintenance_event.dart';
part 'down_for_maintenance_state.dart';

class DownForMaintenanceBloc
    extends Bloc<DownForMaintenanceEvent, DownForMaintenanceState> {
  DownForMaintenanceBloc({required this.remoteConfigRepository})
      : super(DownForMaintenanceState());

  final RemoteConfigRepository remoteConfigRepository;

  @override
  Stream<DownForMaintenanceState> mapEventToState(
    DownForMaintenanceEvent event,
  ) async* {
    if (event is CheckStatus) {
      bool status = await remoteConfigRepository.getDownForMaintenanceStatus();
      yield DownForMaintenanceState(downForMaintenance: status);
    }
  }
}
