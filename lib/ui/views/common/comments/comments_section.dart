import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/views/common/comments/comments_cubit.dart';
import 'package:intheloopapp/ui/views/common/loop_view/loop_view_cubit.dart';
import 'package:intheloopapp/ui/widgets/comments/comments_header.dart';
import 'package:intheloopapp/ui/widgets/comments/comments_list.dart';
import 'package:intheloopapp/ui/widgets/comments/comments_text_field.dart';

class CommentsSection extends StatelessWidget {
  const CommentsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseRepository databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);
    AuthRepository authRepo = RepositoryProvider.of<AuthRepository>(context);

    return BlocBuilder<LoopViewCubit, LoopViewState>(
      builder: (context, state) {
        return StreamBuilder<UserModel>(
          stream: authRepo.user,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            UserModel currentUser = snapshot.data!;

            return BlocProvider(
              create: (context) => CommentsCubit(
                loop: state.loop,
                loopViewCubit: context.read<LoopViewCubit>(),
                currentUser: currentUser,
                databaseRepository: databaseRepository,
              )..initComments(),
              child: DraggableScrollableSheet(
                initialChildSize: 0.75,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Theme.of(context).canvasColor.withOpacity(0.9),
                    ),
                    child: Column(
                      children: [
                        CommentsHeader(),
                        CommentsList(scrollController: scrollController),
                        CommentsTextField(),
                        SizedBox(height: 20),
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
