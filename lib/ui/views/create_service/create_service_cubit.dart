import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/widgets/create_service_view/service_description.dart';
import 'package:intheloopapp/ui/widgets/create_service_view/service_title.dart';

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
          title: ServiceTitle.dirty(title.trim()),
        ),
      );

  void onDescriptionChange(String description) => emit(
        state.copyWith(
          description: ServiceDescription.dirty(description.trim()),
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
    try {
      if (state.status.isInProgress) return;

      if (!state.isValid) {
        throw Exception('Invalid form');
      }

      final service = Service.empty().copyWith(
        userId: currentUserId,
        title: state.title.value,
        description: state.description.value,
        rate: state.rate,
        rateType: state.rateType,
      );
      await database.createService(service);

      onCreated.call(service);

      nav.add(const Pop());
    } catch (e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      rethrow;
    }
  }
}
