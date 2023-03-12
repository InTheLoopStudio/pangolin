import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';

class RequestToBookButton extends StatelessWidget {
  const RequestToBookButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationBloc = context.read<NavigationBloc>();
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return (state.currentUser.id != state.visitedUser.id &&
                state.visitedUser.isNotVenue &&
                state.currentUser.isVenue)
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CupertinoButton.filled(
                  onPressed: () {
                    navigationBloc.add(PushCreateBooking(state.visitedUser.id));
                  },
                  child: const Text('Request to Book'),
                ),
              )
            : const SizedBox(
                height: 2,
              );
      },
    );
  }
}
