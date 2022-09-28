import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/dynamic_link_repository.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';

part 'dynamic_link_event.dart';
part 'dynamic_link_state.dart';

class DynamicLinkBloc extends Bloc<DynamicLinkEvent, DynamicLinkState> {
  DynamicLinkBloc({
    required this.navigationBloc,
    required this.dynamicLinkRepository,
    required this.databaseRepository,
  }) : super(DynamicLinkInitial()) {
    on<MonitorDynamicLinks>((event, emit) {
      dynamicLinkRepository.getDynamicLinks().listen((event) async {
        print('new dynamic link');
        switch (event.type) {
          case DynamicLinkType.CreatePost:
            navigationBloc.add(const ChangeTab(selectedTab: 2));
            break;
          case DynamicLinkType.ShareLoop:
            if (event.id != null) {
              final shareLoop = await databaseRepository.getLoopById(
                event.id ?? '',
              );
              navigationBloc.add(PushLoop(shareLoop));
            }
            break;
          case DynamicLinkType.ShareProfile:
            if (event.id != null) {
              navigationBloc.add(PushProfile(event.id ?? ''));
            }
            break;
        }
      });

      emit(DynamicLinkInitial());
    });
  }

  final NavigationBloc navigationBloc;
  final DynamicLinkRepository dynamicLinkRepository;
  final DatabaseRepository databaseRepository;
}
