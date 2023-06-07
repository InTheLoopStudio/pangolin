import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/common/loop_view/loop_view_cubit.dart';

class AudioDescription extends StatelessWidget {
  const AudioDescription({
    required this.loop,
    required this.user,
    super.key,
  });
  final Loop loop;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final navigationBloc = context.read<NavigationBloc>();

    return BlocBuilder<LoopViewCubit, LoopViewState>(
      builder: (context, state) {
        return Container(
          height: 70,
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  navigationBloc.add(PushProfile(user.id, Some(user)));
                },
                child: Row(
                  children: [
                    Text(
                      user.displayName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    if (state.isVerified)
                      const Icon(
                        Icons.verified,
                        size: 18,
                        color: tappedAccent,
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.music_note,
                    size: 24,
                    color: Colors.white,
                  ),
                  Text(
                    loop.title.unwrapOr('Untitled Loop'),
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
