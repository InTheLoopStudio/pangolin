import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_banner/card_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/app_logger.dart';
import 'package:intheloopapp/data/audio_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/linkify.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/common/loading/loading_container.dart';
import 'package:intheloopapp/ui/widgets/common/conditional_parent_widget.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/attachments.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/control_buttons.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_container_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/show_interest_button.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/title_text.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/user_info.dart';
import 'package:intheloopapp/ui/widgets/common/user_avatar.dart';

class LoopContainer extends StatefulWidget {
  const LoopContainer({
    required this.loop,
    super.key,
  });

  final Loop loop;

  @override
  State<LoopContainer> createState() => _LoopContainerState();
}

class _LoopContainerState extends State<LoopContainer>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Widget _opportunity({
    required Widget child,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              width: 3,
              color: tappedAccent,
            ),
          ),
          child: child,
        ),
      );

  Widget _loopContainer({
    required NavigationBloc navigationBloc,
    required UserModel loopUser,
    required String currentUserId,
  }) =>
      GestureDetector(
        onTap: () => navigationBloc.add(
          PushLoop(widget.loop),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: CardBanner(
            text: 'tapped',
            position: CardBannerPosition.TOPRIGHT,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserInfo(
                  loopUser: loopUser,
                  timestamp: widget.loop.timestamp,
                ),
                TitleText(title: widget.loop.title),
                if (widget.loop.description.isNotEmpty)
                  Column(
                    children: [
                      Linkify(
                        text: widget.loop.description,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                  )
                else
                  const SizedBox.shrink(),
                Attachments(
                  loop: widget.loop,
                  loopUser: loopUser,
                ),
                ShowInterestButton(
                  loop: widget.loop,
                ),
                ControlButtons(
                  loop: widget.loop,
                  currentUserId: currentUserId,
                ),
              ],
            ),
          ),
        ),
      );

  Widget _audioLoopContainer({
    required NavigationBloc navigationBloc,
    required UserModel loopUser,
    required String currentUserId,
  }) =>
      GestureDetector(
        onTap: () => navigationBloc.add(
          PushLoop(widget.loop),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      loopUser.profilePicture!,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserInfo(
                        loopUser: loopUser,
                        timestamp: widget.loop.timestamp,
                      ),
                      TitleText(title: widget.loop.title),
                      const SizedBox(height: 14),
                      if (widget.loop.description.isNotEmpty)
                        Column(
                          children: [
                            Linkify(
                              text: widget.loop.description,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],
                        )
                      else
                        const SizedBox.shrink(),
                      Attachments(
                        loop: widget.loop,
                        loopUser: loopUser,
                      ),
                    ],
                  ),
                ),
              ),
              ShowInterestButton(
                loop: widget.loop,
              ),
              const SizedBox(height: 8),
              ControlButtons(
                loop: widget.loop,
                currentUserId: currentUserId,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final navigationBloc = context.read<NavigationBloc>();
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);

    return BlocSelector<OnboardingBloc, OnboardingState, UserModel?>(
      selector: (state) => (state is Onboarded) ? state.currentUser : null,
      builder: (context, currentUser) {
        if (currentUser == null) {
          logger.error('currentUser is null', stackTrace: StackTrace.current);
          return const ListTile(
            leading: UserAvatar(
              radius: 25,
            ),
            title: Text('ERROR'),
            subtitle: Text("something isn't working right :/"),
          );
        }

        return FutureBuilder<Option<UserModel>>(
          future: databaseRepository.getUserById(widget.loop.userId),
          builder: (context, userSnapshot) {
            final loopUser = userSnapshot.data;
            logger.logAnalyticsEvent(
              name: 'loop_view',
              parameters: {
                'loop_id': widget.loop.id,
                'user_id': widget.loop.userId,
              },
            );

            return switch (loopUser) {
              null => const LoadingContainer(),
              None() => const LoadingContainer(),
              Some(:final value) => BlocProvider<LoopContainerCubit>(
                  create: (context) => LoopContainerCubit(
                    databaseRepository: databaseRepository,
                    loop: widget.loop,
                    currentUser: currentUser,
                    audioRepo: context.read<AudioRepository>(),
                  ),
                  child: BlocBuilder<LoopContainerCubit, LoopContainerState>(
                    builder: (context, state) {
                      return ConditionalParentWidget(
                        condition: widget.loop.isOpportunity,
                        conditionalBuilder: _opportunity,
                        child: () {
                          if (widget.loop.audioPath.isSome &&
                              value.profilePicture != null) {
                            return _audioLoopContainer(
                              navigationBloc: navigationBloc,
                              loopUser: value,
                              currentUserId: currentUser.id,
                            );
                          }

                          return _loopContainer(
                            navigationBloc: navigationBloc,
                            loopUser: value,
                            currentUserId: currentUser.id,
                          );
                        }(),
                      );
                    },
                  ),
                ),
            };
          },
        );
      },
    );
  }
}
