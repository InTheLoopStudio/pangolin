import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/common/easter_egg_placeholder.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/views/send_badge/send_badge_view.dart';
import 'package:intheloopapp/ui/widgets/common/badge_container/badge_container.dart';

class VenueDashboard extends StatefulWidget {
  const VenueDashboard({Key? key, required this.scrollController})
      : super(key: key);

  final ScrollController scrollController;

  @override
  VenueDashboardState createState() => VenueDashboardState();
}

class VenueDashboardState extends State<VenueDashboard> {
  late ProfileCubit _profileCubit;

  Timer? _debounce;
  ScrollController get _scrollController => widget.scrollController;

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      if (_isBottom) _profileCubit.fetchMoreUserCreatedBadges();
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _profileCubit = context.read<ProfileCubit>();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        switch (state.userCreatedBadgeStatus) {
          case UserCreatedBadgesStatus.initial:
            return const EasterEggPlaceholder(
              text: 'Waiting for new badges...',
            );
          case UserCreatedBadgesStatus.failure:
            return const Center(child: Text('failed to fetch badges'));

          case UserCreatedBadgesStatus.success:
            if (state.userCreatedBadges.isEmpty ||
                state.visitedUser.deleted == true) {
              return const EasterEggPlaceholder(text: 'No Badges Yet');
            }

            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute<SendBadgeView>(
                            builder: (context) => const SendBadgeView(),
                          ),
                        ),
                        child: const Text('Create Badge'),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute<SendBadgeView>(
                            builder: (context) => const SendBadgeView(),
                          ),
                        ),
                        child: const Text('Send Badge'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      const Text(
                        'Created Badges',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return index >=
                                            state.userCreatedBadges.length
                                        ? const Center(
                                            child: SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1.5,
                                              ),
                                            ),
                                          )
                                        : BadgeContainer(
                                            badge:
                                                state.userCreatedBadges[index],
                                          );
                                  },
                                  itemCount:
                                      state.hasReachedMaxUserCreatedBadges
                                          ? state.userCreatedBadges.length
                                          : state.userCreatedBadges.length + 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}
