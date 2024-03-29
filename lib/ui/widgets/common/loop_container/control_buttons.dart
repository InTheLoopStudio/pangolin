import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/dynamic_link_repository.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/like_button.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_container_cubit.dart';
import 'package:share_plus/share_plus.dart';

class ControlButtons extends StatelessWidget {
  const ControlButtons({
    required this.currentUserId,
    required this.loop,
    super.key,
  });

  final Loop loop;
  final String currentUserId;

  void _showActionSheet(BuildContext context) {
    final dynamic = context.read<DynamicLinkRepository>();
    final database = context.read<DatabaseRepository>();
    final nav = context.read<NavigationBloc>();
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(loop.title.unwrapOr('Untitled Loop')),
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
                nav
                  ..add(const Pop())
                  ..add(const Pop());
              },
              child: const Text('Delete Loop'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final database = context.read<DatabaseRepository>();

    return FutureBuilder<bool>(
      future: database.isLiked(currentUserId, loop.id),
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
                Row(
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
                IconButton(
                  onPressed: () => _showActionSheet(context),
                  icon: const Icon(
                    CupertinoIcons.ellipsis,
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
