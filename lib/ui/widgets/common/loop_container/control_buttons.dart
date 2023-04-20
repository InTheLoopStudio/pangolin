import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/dynamic_link_repository.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/like_button.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_container_cubit.dart';
import 'package:share_plus/share_plus.dart';

class ControlButtons extends StatelessWidget {
  const ControlButtons({
    required this.currentUserId,
    required this.loopId,
    super.key,
  });

  final String loopId;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final dynamic = context.read<DynamicLinkRepository>();
    final database = context.read<DatabaseRepository>();

    return FutureBuilder<bool>(
      future: database.isLiked(currentUserId, loopId),
      builder: (context, snapshot) {
        bool? isLiked;

        if (snapshot.hasData) {
          isLiked = snapshot.data ?? false;
        }

        isLiked ??= false;

        return BlocBuilder<LoopContainerCubit, LoopContainerState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                LikeButton(
                  isLiked: isLiked,
                  likeCount: state.likeCount,
                  onLike: context.read<LoopContainerCubit>().toggleLoopLike,
                ),
                GestureDetector(
                  onTap: () => context.read<NavigationBloc>().add(
                        PushLoop(
                          state.loop,
                          showComments: true,
                          autoPlay: false,
                        ),
                      ),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.bubble_middle_bottom,
                        size: 18,
                        color: Color(0xFF757575),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${state.commentCount}',
                        style: const TextStyle(
                          color: Color(0xFF757575),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  // onTap: null,
                  child: const Row(
                    children: [
                      Icon(
                        CupertinoIcons.arrow_2_squarepath,
                        color: Color(0xFF444444),
                        size: 18,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'soon',
                        style: TextStyle(
                          color: Color(0xFF444444),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await context.read<LoopContainerCubit>().incrementShares();

                    final link =
                        await dynamic.getShareLoopDynamicLink(state.loop);

                    await Share.share(
                      'Check out this loop on Tapped $link',
                    );
                  },
                  child: const Icon(
                    CupertinoIcons.share,
                    size: 18,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
