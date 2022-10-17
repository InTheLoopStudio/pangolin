import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/views/home/feeds_list/feeds_list_cubit.dart';
import 'package:intheloopapp/ui/widgets/profile_view/notification_icon_button.dart';

class ControlButtons extends StatelessWidget {
  const ControlButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedsListCubit, FeedsListState>(
      builder: (context, state) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: SizedBox.shrink(),
                ),
                Row(
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
                Padding(
                  padding: EdgeInsets.zero,
                  // padding: const EdgeInsets.only(
                  //     vertical: 15.0,
                  //     horizontal: 20.0,
                  //     ),
                  child: GestureDetector(
                    onTap: () => context
                        .read<NavigationBloc>()
                        .add(const PushActivity()),
                    child: const NotificationIconButton(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
