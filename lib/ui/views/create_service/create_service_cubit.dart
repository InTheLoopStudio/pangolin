import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';

part 'create_service_state.dart';

class CreateServiceCubit extends Cubit<CreateServiceState> {
  CreateServiceCubit({
    required this.database,
    required this.nav,
    required this.currentUserId,
  }) : super(const CreateServiceState());

  final DatabaseRepository database;
  final NavigationBloc nav;

  final String currentUserId;

  void onTitleChange(String title) => emit(
        state.copyWith(
          title: title.trim(),
        ),
      );
  void onDescriptionChange(String description) => emit(
        state.copyWith(
          description: description.trim(),
        ),
      );
  void onRateChange(int rate) => emit(
        state.copyWith(
          rate: rate,
        ),
      );
  void onRateTypeChange(RateType rateType) => emit(
        state.copyWith(
          rateType: rateType,
        ),
      );

  Future<void> submit(void Function(Service) onCreated) async {
    // add validation

    final service = Service.empty().copyWith(
      userId: currentUserId,
      title: state.title,
      description: state.description,
      rate: state.rate,
      rateType: state.rateType,
    );
    await database.createService(service);

    onCreated.call(service);

    nav.add(const Pop());
  }
}
