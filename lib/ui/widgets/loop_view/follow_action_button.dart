import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/views/common/loop_view/loop_view_cubit.dart';
import 'package:intheloopapp/ui/widgets/loop_view/follow_icon.dart';

class FollowActionButton extends StatelessWidget {
  const FollowActionButton({Key? key}) : super(key: key);

  static const double ActionWidgetSize = 60;
  static const double ActionIconSize = 35;
  static const double ProfileImageSize = 50;
  static const double PlusIconSize = 20;

  @override
  Widget build(BuildContext context) {
    final authRepo = RepositoryProvider.of<AuthRepository>(context);
    return StreamBuilder<UserModel>(
      stream: authRepo.user,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final currentUser = snapshot.data!;

        return BlocBuilder<LoopViewCubit, LoopViewState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: context.read<LoopViewCubit>().toggleFollow,
              child: SizedBox(
                width: 60,
                height: 60,
                child: Stack(
                  children: [
                    Positioned(
                      left: (ActionWidgetSize / 2) - (ProfileImageSize / 2),
                      child: Container(
                        height: ProfileImageSize,
                        width: ProfileImageSize,
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(ProfileImageSize / 2),
                        ),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundImage: state.user.profilePicture.isEmpty
                              ? const AssetImage('assets/default_avatar.png')
                                  as ImageProvider
                              : CachedNetworkImageProvider(
                                  state.user.profilePicture,
                                ),
                        ),
                      ),
                    ),
                    if (currentUser.id == state.user.id)
                      const SizedBox.shrink()
                    else
                      const FollowIcon(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
