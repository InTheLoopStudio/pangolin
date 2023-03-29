import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/audio_feeds/audio_feeds_list/audio_feeds_list_cubit.dart';

class ControlButtons extends StatelessWidget {
  const ControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioFeedsListCubit, AudioFeedsListState>(
      builder: (context, state) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => state.pageController.jumpToPage(0),
                  child: Text(
                    'Following',
                    style: state.currentIndex == 0
                        ? const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )
                        : const TextStyle(
                            color: Colors.white,
                          ),
                  ),
                ),
                const SizedBox(width: 15),
                GestureDetector(
                  onTap: () => state.pageController.jumpToPage(1),
                  child: Text(
                    'For you',
                    style: state.currentIndex == 1
                        ? const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )
                        : const TextStyle(
                            color: Colors.white,
                          ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
