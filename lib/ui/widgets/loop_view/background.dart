import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/common/loop_view/loop_view_cubit.dart';
import 'package:just_audio/just_audio.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoopViewCubit, LoopViewState>(
      builder: (context, state) {
        return StreamBuilder<PlayerState>(
          stream: state.audioController.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;

            if (playerState == null) {
              return const SizedBox.shrink();
            }

            final processingState = playerState.processingState;

            if (processingState == ProcessingState.completed) {
              context.read<LoopViewCubit>().nextLoop();
            }

            return GestureDetector(
              onTap: () => context.read<LoopViewCubit>().togglePlaying(),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  // borderRadius: const BorderRadius.only(
                  //   bottomRight: Radius.circular(15),
                  //   bottomLeft: Radius.circular(15),
                  // ),
                  image: DecorationImage(
                    image: state.user.profilePicture.isEmpty
                        ? const AssetImage('assets/default_avatar.png')
                            as ImageProvider
                        : CachedNetworkImageProvider(
                            state.user.profilePicture,
                          ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(),
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
