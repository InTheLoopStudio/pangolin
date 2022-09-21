import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/views/home/feeds_list/feeds_list_cubit.dart';
import 'package:intheloopapp/ui/widgets/profile_view/notification_icon_button.dart';

class ControlButtons extends StatelessWidget {
  ControlButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedsListCubit, FeedsListState>(
      builder: (context, state) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: SizedBox.shrink(),
                ),
                Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => state.pageController.jumpToPage(0),
                        child: Text(
                          'Following',
                          style: state.currentIndex == 0
                              ? TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )
                              : TextStyle(
                                  color: Colors.white,
                                ),
                        ),
                      ),
                      SizedBox(width: 15),
                      GestureDetector(
                          onTap: () => state.pageController.jumpToPage(1),
                          child: Text(
                            'For you',
                            style: state.currentIndex == 1
                                ? TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  )
                                : TextStyle(
                                    color: Colors.white,
                                  ),
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    // vertical: 15.0,
                    // horizontal: 20.0,
                  ),
                  child: GestureDetector(
                    onTap: () =>
                        context.read<NavigationBloc>().add(PushActivity()),
                    child: NotificationIconButton(),
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
