import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/data/remote_config_repository.dart';

part 'down_for_maintenance_event.dart';
part 'down_for_maintenance_state.dart';

class DownForMaintenanceBloc
    extends Bloc<DownForMaintenanceEvent, DownForMaintenanceState> {
  DownForMaintenanceBloc({required this.remoteConfigRepository})
      : super(DownForMaintenanceState()) {
    on<CheckStatus>((event, emit) async {
      bool status = await remoteConfigRepository.getDownForMaintenanceStatus();
      emit(DownForMaintenanceState(downForMaintenance: status));
    });
  }

  final RemoteConfigRepository remoteConfigRepository;
}
