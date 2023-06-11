import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/dynamic_link_repository.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/linkify.dart';
import 'package:intheloopapp/ui/app_theme_cubit.dart';
import 'package:intheloopapp/ui/views/common/comments/comments_cubit.dart';
import 'package:intheloopapp/ui/views/common/loading/loop_loading_view.dart';
import 'package:intheloopapp/ui/views/common/loop_view/loop_view_cubit.dart';
import 'package:intheloopapp/ui/views/error/error_view.dart';
import 'package:intheloopapp/ui/widgets/comments/comments_list.dart';
import 'package:intheloopapp/ui/widgets/comments/comments_text_field.dart';
import 'package:intheloopapp/ui/widgets/common/conditional_parent_widget.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/attachments.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/like_button.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_container.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/show_interest_button.dart';
import 'package:intheloopapp/ui/widgets/common/user_avatar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

class LoopView extends StatelessWidget {
  const LoopView({
    required this.loop,
    this.loopUser = const None(),
    super.key,
  });

  final Loop loop;
  final Option<UserModel> loopUser;

  void _showActionSheet(
    BuildContext context,
    String currentUserId,
  ) {
    final dynamic = context.read<DynamicLinkRepository>();
    final database = context.read<DatabaseRepository>();
    final nav = context.read<NavigationBloc>();
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(loop.title.asNullable() ?? 'Untitled Loop'),
        message: Text(loop.description),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              final link = await dynamic.getShareLoopDynamicLink(loop);

              await Share.share(
                'Check out this loop on Tapped $link',
              );

              nav.add(const Pop());
            },
            child: const Text('Share'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              nav.add(const Pop());

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Loop Reported'),
                ),
              );
              await database.reportLoop(
                loop: loop,
                reporterId: currentUserId,
              );
            },
            child: const Text('Report Loop'),
          ),
          if (loop.userId == currentUserId)
            CupertinoActionSheetAction(
              /// This parameter indicates the action would perform
              /// a destructive action such as delete or exit and turns
              /// the action's text color to red.
              isDestructiveAction: true,
              onPressed: () async {
                await database.deleteLoop(loop);
                nav.add(const Pop());
              },
              child: const Text('Delete Loop'),
            ),
        ],
      ),
    );
  }

  Widget _buildLoopView(
    NavigationBloc nav,
    DatabaseRepository database,
    UserModel currentUser,
    UserModel user,
  ) =>
      BlocProvider<LoopViewCubit>(
        create: (context) => LoopViewCubit(
          databaseRepository: database,
          loop: loop,
          currentUser: currentUser,
          user: user,
        )
          ..initLoopLikes()
          ..checkVerified(),
        child: BlocBuilder<LoopViewCubit, LoopViewState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                title: const Text('Loop'),
              ),
              body: BlocProvider(
                create: (context) => CommentsCubit(
                  currentUser: currentUser,
                  databaseRepository: database,
                  loop: loop,
                  loopViewCubit: context.read<LoopViewCubit>(),
                )..initComments(),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: LoopContainer(
                        loop: loop,
                        commentStream: context
                            .read<LoopViewCubit>()
                            .commentController
                            .stream,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 8),
                    ),
                    const SliverToBoxAdapter(
                      child: CommentsTextField(),
                    ),
                    const CommentsList(),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 50),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    final nav = context.read<NavigationBloc>();
    final database = RepositoryProvider.of<DatabaseRepository>(context);
    return BlocSelector<OnboardingBloc, OnboardingState, UserModel?>(
      selector: (state) => (state is Onboarded) ? state.currentUser : null,
      builder: (context, currentUser) {
        if (currentUser == null) {
          return const ErrorView();
        }

        return switch (loopUser) {
          None() => FutureBuilder<Option<UserModel>>(
              future: database.getUserById(loop.userId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const LoopLoadingView();
                }

                final user = snapshot.data;
                return switch (user) {
                  null => const LoopLoadingView(),
                  None() => const LoopLoadingView(),
                  Some(:final value) => _buildLoopView(
                      nav,
                      database,
                      currentUser,
                      value,
                    ),
                };
              },
            ),
          Some(:final value) => _buildLoopView(
              nav,
              database,
              currentUser,
              value,
            ),
        };
      },
    );
  }
}
