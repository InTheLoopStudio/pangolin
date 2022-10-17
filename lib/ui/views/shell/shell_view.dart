import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/views/common/loading/loading_view.dart';
import 'package:intheloopapp/ui/views/home/feeds_list/feeds_list_view.dart';
import 'package:intheloopapp/ui/views/messaging/channel_list_view.dart';
import 'package:intheloopapp/ui/views/profile/profile_view.dart';
// import 'package:intheloopapp/ui/views/profile/profile_view.dart';
import 'package:intheloopapp/ui/views/search/search_view.dart';
import 'package:intheloopapp/ui/views/upload_loop/upload_view.dart';
import 'package:intheloopapp/ui/widgets/shell_view/bottom_toolbar.dart';

class ShellView extends StatelessWidget {
  const ShellView({
    Key? key,
    this.initialTab = 0,
  }) : super(key: key);

  final int initialTab;

  @override
  Widget build(BuildContext context) {
    final authRepo = RepositoryProvider.of<AuthRepository>(context);

    return StreamBuilder<UserModel>(
      stream: authRepo.user,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final currentUser = snapshot.data!;

          return BlocBuilder<NavigationBloc, NavigationState>(
            builder: (context, state) {
              return Scaffold(
                body: IndexedStack(
                  index: state.selectedTab,
                  children: [
                    const FeedsListView(), // getstream.io activity feed soon?
                    const SearchView(),
                    UploadView(),
                    // ActivityView(),
                    const MessagingChannelListView(),
                    ProfileView(visitedUserId: currentUser.id),
                    // ProfileView(visitedUserId: currentUser.id)
                  ],
                ),
                bottomNavigationBar: BottomToolbar(
                  user: currentUser,
                ),
              );
            },
          );
        }

        return const LoadingView();
      },
    );
  }
}
