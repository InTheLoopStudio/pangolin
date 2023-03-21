import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/common/comments/comments_cubit.dart';
import 'package:intheloopapp/ui/views/common/loop_view/loop_view_cubit.dart';
import 'package:intheloopapp/ui/widgets/comments/comments_header.dart';
import 'package:intheloopapp/ui/widgets/comments/comments_list.dart';
import 'package:intheloopapp/ui/widgets/comments/comments_text_field.dart';

class CommentsSection extends StatelessWidget {
  const CommentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);

    return BlocBuilder<LoopViewCubit, LoopViewState>(
      builder: (context, loopState) {
        return BlocSelector<OnboardingBloc, OnboardingState, Onboarded>(
          selector: (state) => state as Onboarded,
          builder: (context, userState) {
            final currentUser = userState.currentUser;

            return BlocProvider(
              create: (context) => CommentsCubit(
                loop: loopState.loop,
                loopViewCubit: context.read<LoopViewCubit>(),
                currentUser: currentUser,
                databaseRepository: databaseRepository,
              )..initComments(),
              child: DraggableScrollableSheet(
                initialChildSize: 0.75,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Theme.of(context).canvasColor.withOpacity(0.9),
                    ),
                    child: Column(
                      children: [
                        const CommentsHeader(),
                        CommentsList(scrollController: scrollController),
                        const CommentsTextField(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
