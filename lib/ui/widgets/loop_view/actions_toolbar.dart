import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/dynamic_link_repository.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/common/loop_view/loop_view_cubit.dart';
import 'package:intheloopapp/ui/widgets/loop_view/follow_action_button.dart';
import 'package:intheloopapp/ui/widgets/loop_view/social_action_button.dart';
import 'package:share_plus/share_plus.dart';

class ActionsToolbar extends StatelessWidget {

  const ActionsToolbar({
    Key? key,
    required this.user,
    required this.loop,
  }) : super(key: key);
  final UserModel user;
  final Loop loop;

  static const double ActionWidgetSize = 60;
  static const double ActionIconSize = 35;
  static const double ProfileImageSize = 50;
  static const double PlusIconSize = 20;

  @override
  Widget build(BuildContext context) {
    final dynamicLinkRepository =
        RepositoryProvider.of<DynamicLinkRepository>(context);
    return BlocBuilder<LoopViewCubit, LoopViewState>(
      builder: (context, state) {
        return SizedBox(
          width: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FollowActionButton(),
              SocialActionButton(
                icon: state.isLiked
                    ? CupertinoIcons.heart_fill
                    : CupertinoIcons.heart,
                color: state.isLiked ? tappedAccent : Colors.grey[300],
                title: state.likesCount.toString(),
                onTap: () => context.read<LoopViewCubit>().toggleLikeLoop(),
              ),
              SocialActionButton(
                icon: Icons.comment,
                title: state.commentsCount.toString(),
                color: Colors.grey[300],
                onTap: () => context.read<LoopViewCubit>().toggleComments(),
              ),
              // SocialActionButton(
              //   icon: Icons.download,
              //   title: state.loop.comments.toString(),
              //   onTap: null,
              // ),
              SocialActionButton(
                icon: Icons.share,
                title: 'Share',
                color: Colors.grey[300],
                onTap: () async {
                  context.read<LoopViewCubit>().incrementShares();
                  final link =
                      await dynamicLinkRepository.getShareLoopDynamicLink(loop);
                  await Share.share('Check out this loop on Tapped $link');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
