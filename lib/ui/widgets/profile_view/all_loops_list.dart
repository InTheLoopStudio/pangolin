import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/common/easter_egg_placeholder.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_container.dart';

class AllLoopsList extends StatefulWidget {
  const AllLoopsList({Key? key, required this.scrollController})
      : super(key: key);

  final ScrollController scrollController;

  @override
  AllLoopsListState createState() => AllLoopsListState();
}

class AllLoopsListState extends State<AllLoopsList> {
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
      if (_isBottom) _profileCubit.fetchMoreLoops();
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
        switch (state.loopStatus) {
          case LoopsStatus.initial:
            return const EasterEggPlaceholder(text: 'Waiting for New Loops...');

          case LoopsStatus.failure:
            return const Center(child: Text('failed to fetch posts'));

          case LoopsStatus.success:
            if (state.userLoops.isEmpty || state.visitedUser.deleted == true) {
              return const EasterEggPlaceholder(text: 'No Posts');
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return index >= state.userLoops.length
                              ? const Center(
                                  child: SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    LoopContainer(
                                      loop: state.userLoops[index],
                                    ),
                                    Container(
                                      color: Colors.black,
                                      height: 1,
                                    )
                                  ],
                                );
                        },
                        itemCount: state.hasReachedMaxLoops
                            ? state.userLoops.length
                            : state.userLoops.length + 1,
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
