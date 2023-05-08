import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/app_logger.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/dynamic_link_repository.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';

part 'dynamic_link_event.dart';
part 'dynamic_link_state.dart';

class DynamicLinkBloc extends Bloc<DynamicLinkEvent, DynamicLinkState> {
  DynamicLinkBloc({
    required this.onboardingBloc,
    required this.navigationBloc,
    required this.dynamicLinkRepository,
    required this.databaseRepository,
  }) : super(DynamicLinkInitial()) {
    on<MonitorDynamicLinks>((event, emit) {
      logger.debug('monitoring dynamic links');
      dynamicLinkRepository.getDynamicLinks().listen((event) async {
        try {
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
                if (shareLoop != null) {
                  navigationBloc.add(PushLoop(shareLoop));
                }
              }
              break;
            case DynamicLinkType.shareProfile:
              if (event.id != null) {
                navigationBloc.add(PushProfile(event.id!));
              }
              break;
            case DynamicLinkType.connectStripeRedirect:
              if (event.id == null || event.id == '') {
                break;
              }
              // add accountId to the users data
              if (onboardingBloc.state is! Onboarded) {
                break;
              }

              final currentUser =
                  (onboardingBloc.state as Onboarded).currentUser.copyWith(
                        stripeConnectedAccountId: event.id,
                      );

              onboardingBloc.add(
                UpdateOnboardedUser(
                  user: currentUser,
                ),
              );

              navigationBloc.add(const PushSettings());
              break;
            case DynamicLinkType.connectStripeRefresh:
              if (event.id != null) {
                // resend the create account request?
              }
              break;
          }
        } catch (e, s) {
          logger.error('dynamic link error', error: e, stackTrace: s);
        }
      });

      emit(DynamicLinkInitial());
    });
  }

  final NavigationBloc navigationBloc;
  final OnboardingBloc onboardingBloc;
  final DynamicLinkRepository dynamicLinkRepository;
  final DatabaseRepository databaseRepository;
}
