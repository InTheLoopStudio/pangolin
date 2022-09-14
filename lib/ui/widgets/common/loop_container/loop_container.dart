import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/dynamic_link_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/comments.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/like_button.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_container_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_seek_bar.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_title.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/play_pause_button.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/timestamp.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share_plus/share_plus.dart';

class LoopContainer extends StatelessWidget {
  const LoopContainer({
    Key? key,
    required this.loop,
  }) : super(key: key);

  final Loop loop;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthenticationBloc, AuthenticationState, Authenticated>(
      selector: (state) => state as Authenticated,
      builder: (context, state) {
        UserModel currentUser = state.currentUser;

        return BlocProvider(
          create: (context) => LoopContainerCubit(
            databaseRepository: context.read<DatabaseRepository>(),
            currentUser: currentUser,
            loop: loop,
          )
            ..initLoopLikes()
            ..initAudio(),
          child: Slidable(
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                BlocBuilder<LoopContainerCubit, LoopContainerState>(
                  builder: (context, state) {
                    return SlidableAction(
                      onPressed: (context) {
                        context.read<LoopContainerCubit>().deleteLoop();
                        context.read<ProfileCubit>().deleteLoop(loop);
                      },
                      backgroundColor: Colors.red[600]!,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    );
                  },
                ),
                SlidableAction(
                  onPressed: (context) async {
                    final String link = await context
                        .read<DynamicLinkRepository>()
                        .getShareLoopDynamicLink(loop);
                    await Share.share(
                        'Check out this loop on In The Loop $link');
                  },
                  backgroundColor: tappedAccent,
                  foregroundColor: Colors.white,
                  icon: Icons.share,
                  label: 'Share',
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      PlayPauseButton(),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: LoopTitle(),
                            ),
                            SizedBox(height: 10),
                            LoopSeekBar(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          LikeButton(),
                          const SizedBox(width: 20.0),
                          Comments(),
                        ],
                      ),
                      Timestamp(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
