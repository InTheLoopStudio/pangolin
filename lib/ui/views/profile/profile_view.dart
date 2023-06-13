import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/linkify.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/common/loading/loading_view.dart';
import 'package:intheloopapp/ui/views/error/error_view.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/widgets/profile_view/badges_sliver.dart';
import 'package:intheloopapp/ui/widgets/profile_view/bookings_sliver.dart';
import 'package:intheloopapp/ui/widgets/profile_view/epk_button.dart';
import 'package:intheloopapp/ui/widgets/profile_view/follow_button.dart';
import 'package:intheloopapp/ui/widgets/profile_view/follower_count.dart';
import 'package:intheloopapp/ui/widgets/profile_view/following_count.dart';
import 'package:intheloopapp/ui/widgets/profile_view/loops_sliver.dart';
import 'package:intheloopapp/ui/widgets/profile_view/more_options_button.dart';
import 'package:intheloopapp/ui/widgets/profile_view/opportunity_sliver.dart';
import 'package:intheloopapp/ui/widgets/profile_view/request_to_book.dart';
import 'package:intheloopapp/ui/widgets/profile_view/social_media_icons.dart';
import 'package:intheloopapp/utils.dart';

class ProfileView extends StatelessWidget {
  ProfileView({
    required this.visitedUserId,
    required this.visitedUser,
    this.collapsedBarHeight = 60.0,
    this.expandedBarHeight = 300.0,
    super.key,
  });

  final String visitedUserId;
  final double collapsedBarHeight;
  final double expandedBarHeight;

  final scrollController = ScrollController();

  // callers can provide a user to avoid a database call
  final Option<UserModel> visitedUser;

  Widget _profilePage(
    UserModel currentUser,
    UserModel visitedUser,
    DatabaseRepository databaseRepository,
    PlacesRepository places,
  ) =>
      BlocProvider(
        create: (context) => ProfileCubit(
          places: places,
          databaseRepository: databaseRepository,
          currentUser: currentUser,
          visitedUser: visitedUser,
        )
          ..getLatestLoop()
          ..getLatestOpportunity()
          ..getLatestBooking()
          ..initBadges()
          ..loadIsFollowing(currentUser.id, visitedUser.id)
          ..loadIsBlocked()
          ..loadIsVerified(visitedUser.id)
          ..initPlace(),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return BlocListener<OnboardingBloc, OnboardingState>(
              listener: (context, userState) {
                if (userState is Onboarded) {
                  if (userState.currentUser.id == visitedUser.id) {
                    context
                        .read<ProfileCubit>()
                        .refetchVisitedUser(newUserData: userState.currentUser);
                  }
                }
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) =>
                    context.read<ProfileCubit>().onNotification(
                          scrollController,
                          expandedBarHeight,
                          collapsedBarHeight,
                        ),
                child: CustomScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: state.isBlocked
                      ? _blockedSlivers(
                          context,
                          state,
                          currentUser,
                          visitedUser,
                        )
                      : _unblockedSlivers(
                          context,
                          state,
                          currentUser,
                          visitedUser,
                        ),
                ),
              ),
            );
          },
        ),
      );

  List<Widget> _unblockedSlivers(
    BuildContext context,
    ProfileState state,
    UserModel currentUser,
    UserModel visitedUser,
  ) =>
      [
        SliverAppBar(
          expandedHeight: expandedBarHeight,
          collapsedHeight: collapsedBarHeight,
          pinned: true,
          stretch: true,
          onStretchTrigger: () async {
            final cubit = context.read<ProfileCubit>();
            await Future.wait([
              HapticFeedback.mediumImpact(),
              cubit.getLatestLoop(),
              cubit.getLatestOpportunity(),
              cubit.getLatestBooking(),
              cubit.initBadges(),
              cubit.refetchVisitedUser(),
              cubit.loadIsFollowing(currentUser.id, visitedUser.id),
              cubit.loadIsVerified(visitedUser.id),
            ]);
          },
          // automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [
              StretchMode.zoomBackground,
              StretchMode.fadeTitle,
            ],
            titlePadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            centerTitle: false,
            title: Text.rich(
              TextSpan(
                text: visitedUser.artistName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
                children: [
                  if (state.isVerified)
                    const WidgetSpan(
                      child: Icon(
                        Icons.verified,
                        size: 18,
                        color: tappedAccent,
                      ),
                      alignment: PlaceholderAlignment.middle,
                    ),
                ],
              ),
              overflow: TextOverflow.fade,
              maxLines: 2,
            ),
            background: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: (visitedUser.profilePicture == null)
                      ? const AssetImage(
                          'assets/default_avatar.png',
                        ) as ImageProvider
                      : CachedNetworkImageProvider(
                          visitedUser.profilePicture!,
                        ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '@${visitedUser.username}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF757575),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (visitedUser.label != 'None')
                      Text(
                        visitedUser.label,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF757575),
                        ),
                      ),
                  ],
                ),
                const MoreOptionsButton(),
                const FollowButton(),
              ],
            ),
          ),
        ),
        if (visitedUser.occupations.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Text(
                visitedUser.occupations.join(', '),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: tappedAccent,
                ),
              ),
            ),
          ),
        if (visitedUser.bio.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Linkify(
                text: visitedUser.bio,
                maxLines: 6,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  // color: Color(0xFF757575),
                ),
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const FollowerCount(),
                const FollowingCount(),
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.location,
                      color: tappedAccent,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      formattedAddress(
                        state.place.addressComponents,
                      ),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        color: tappedAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: SocialMediaIcons(),
          ),
        ),
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const RequestToBookButton(),
              if (visitedUser.epkUrl.isSome) const EPKButton(),
            ],
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 12),
        ),
        const SliverToBoxAdapter(
          child: BookingsSliver(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 18),
        ),
        const SliverToBoxAdapter(
          child: OpportunitySliver(),
        ),
        const SliverToBoxAdapter(
          child: LoopsSliver(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 18),
        ),
        const SliverToBoxAdapter(
          child: BadgesSliver(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 50,
          ),
        ),
      ];

  List<Widget> _blockedSlivers(
    BuildContext context,
    ProfileState state,
    UserModel currentUser,
    UserModel visitedUser,
  ) =>
      [
        SliverAppBar(
          expandedHeight: expandedBarHeight,
          collapsedHeight: collapsedBarHeight,
          pinned: true,
          stretch: true,
          onStretchTrigger: () async {
            final cubit = context.read<ProfileCubit>();
            await Future.wait([
              cubit.getLatestLoop(),
              cubit.getLatestOpportunity(),
              cubit.getLatestBooking(),
              cubit.initBadges(),
              cubit.refetchVisitedUser(),
              cubit.loadIsFollowing(currentUser.id, visitedUser.id),
              cubit.loadIsVerified(visitedUser.id),
            ]);
          },
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [
              StretchMode.zoomBackground,
              StretchMode.fadeTitle,
            ],
            titlePadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            centerTitle: false,
            title: Text.rich(
              TextSpan(
                text: visitedUser.artistName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
                children: [
                  if (state.isVerified)
                    const WidgetSpan(
                      child: Icon(
                        Icons.verified,
                        size: 18,
                        color: tappedAccent,
                      ),
                      alignment: PlaceholderAlignment.middle,
                    )
                  else
                    const WidgetSpan(
                      child: SizedBox.shrink(),
                    ),
                ],
              ),
              overflow: TextOverflow.fade,
              maxLines: 2,
            ),
            background: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: (visitedUser.profilePicture == null)
                      ? const AssetImage(
                          'assets/default_avatar.png',
                        ) as ImageProvider
                      : CachedNetworkImageProvider(
                          visitedUser.profilePicture!,
                        ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text(
                'Blocked',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'You have blocked this user, and they cannot see your profile.',
                textAlign: TextAlign.center,
              ),
              FilledButton(
                onPressed: () => context.read<ProfileCubit>().unblock(),
                child: const Text('Unblock'),
              ),
            ],
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);
    final places = RepositoryProvider.of<PlacesRepository>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocSelector<OnboardingBloc, OnboardingState, UserModel?>(
        selector: (state) => (state is Onboarded) ? state.currentUser : null,
        builder: (context, currentUser) {
          if (currentUser == null) {
            return const ErrorView();
          }

          return switch ((visitedUser, currentUser.id == visitedUserId)) {
            (_, true) => _profilePage(
                currentUser,
                currentUser,
                databaseRepository,
                places,
              ),
            (None(), false) => FutureBuilder<Option<UserModel>>(
                future: databaseRepository.getUserById(visitedUserId),
                builder: (context, snapshot) {
                  final user = snapshot.data;

                  return switch (user) {
                    null => const LoadingView(),
                    None() => const LoadingView(),
                    Some(:final value) => _profilePage(
                        currentUser,
                        value,
                        databaseRepository,
                        places,
                      ),
                  };
                },
              ),
            (Some(:final value), false) => _profilePage(
                currentUser,
                value,
                databaseRepository,
                places,
              ),
          };
        },
      ),
    );
  }
}
