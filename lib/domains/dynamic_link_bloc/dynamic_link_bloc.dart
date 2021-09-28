import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/dynamic_link_repository.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';

part 'dynamic_link_event.dart';
part 'dynamic_link_state.dart';

class DynamicLinkBloc extends Bloc<DynamicLinkEvent, DynamicLinkState> {
  DynamicLinkBloc({
    required this.navigationBloc,
    required this.dynamicLinkRepository,
    required this.databaseRepository,
  }) : super(DynamicLinkInitial());

  final NavigationBloc navigationBloc;
  final DynamicLinkRepository dynamicLinkRepository;
  final DatabaseRepository databaseRepository;

  @override
  Stream<DynamicLinkState> mapEventToState(
    DynamicLinkEvent event,
  ) async* {
    if (event is MonitorDynamicLinks) {
      yield* _mapMonitorDynamicLinksToState();
    }
  }

  Stream<DynamicLinkState> _mapMonitorDynamicLinksToState() async* {
    dynamicLinkRepository.getDynamicLinks().listen((event) async {
      print("new dynamic link");
      switch (event.type) {
        case DynamicLinkType.CreatePost:
          navigationBloc.add(ChangeTab(selectedTab: 2));
          break;
        case DynamicLinkType.ShareLoop:
          if (event.id != null) {
            Loop shareLoop = await databaseRepository.getLoopById(
              event.id ?? '',
            );
            navigationBloc.add(PushLoop(shareLoop));
          }
          break;
        case DynamicLinkType.ShareProfile:
          if (event.id != null) navigationBloc.add(PushProfile(event.id ?? ''));
          break;
      }
    });

    yield DynamicLinkInitial();
  }
}
