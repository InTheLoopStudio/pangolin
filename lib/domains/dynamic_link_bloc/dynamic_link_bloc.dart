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
        // print('new dynamic link');
        switch (event.type) {
          case DynamicLinkType.createPost:
            navigationBloc.add(const ChangeTab(selectedTab: 2));
            break;
          case DynamicLinkType.shareLoop:
            if (event.id != null) {
              final shareLoop = await databaseRepository.getLoopById(
                event.id ?? '',
              );
              navigationBloc.add(PushLoop(shareLoop));
            }
            break;
          case DynamicLinkType.shareProfile:
            if (event.id != null) {
              navigationBloc.add(PushProfile(event.id ?? ''));
            }
            break;
          case DynamicLinkType.connectStripeRedirect:
            if (event.id != null) {
              // add accountId to the users data
              // redirect to settings?
            }
            break;
          case DynamicLinkType.connectStripeRefresh:
            if (event.id != null) {
              // resend the create account request?
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
