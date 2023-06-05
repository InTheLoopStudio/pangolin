import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/app_logger.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_container.dart';

class UserLoopFeed extends StatefulWidget {
  const UserLoopFeed({
    required this.userId,
    super.key,
  });

  final String userId;

  @override
  State<UserLoopFeed> createState() => _UserLoopFeedState();
}

class _UserLoopFeedState extends State<UserLoopFeed> {
  String get _userId => widget.userId;
  Timer? _debounce;
  final _scrollController = ScrollController();
  List<Loop> _userLoops = const [];
  bool _hasReachedMaxLoops = false;
  LoopsStatus _loopStatus = LoopsStatus.initial;
  StreamSubscription<Loop>? _loopListener;
  late DatabaseRepository _databaseRepository;

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> _initLoops({bool clearLoops = true}) async {
    final trace = logger.createTrace('initLoops');
    await trace.start();
    try {
      logger.debug(
        'initLoops $_userId',
      );
      await _loopListener?.cancel();
      if (clearLoops) {
        setState(() {
          _loopStatus = LoopsStatus.initial;
          _userLoops = [];
          _hasReachedMaxLoops = false;
        });
      }

      final userLoops =
          await _databaseRepository.getUserLoops(_userId, limit: 1);
      if (userLoops.isEmpty) {
        setState(() {
          _loopStatus = LoopsStatus.success;
        });
      }

      _loopListener =
          _databaseRepository.userLoopsObserver(_userId).listen((Loop event) {
        try {
          logger.debug('loop { ${event.id} : ${event.title} }');
          setState(() {
            _loopStatus = LoopsStatus.success;
            _userLoops = List.of(_userLoops)..add(event);
          });
        } catch (e, s) {
          logger.error('initLoops error', error: e, stackTrace: s);
        }
      });
    } catch (e, s) {
      logger.error('initLoops error', error: e, stackTrace: s);
    } finally {
      await trace.stop();
    }
  }

  Future<void> _fetchMoreLoops() async {
    if (_hasReachedMaxLoops) return;

    final trace = logger.createTrace('fetchMoreLoops');
    await trace.start();
    try {
      if (_loopStatus == LoopsStatus.initial) {
        await _initLoops();
      }

      final loops = await _databaseRepository.getUserLoops(
        _userId,
        // limit: 10,
        lastLoopId: _userLoops.last.id,
      );

      loops.isEmpty
          ? setState(() {
              _hasReachedMaxLoops = true;
            })
          : setState(() {
              _loopStatus = LoopsStatus.success;
              _userLoops = List.of(_userLoops)..addAll(loops);
              _hasReachedMaxLoops = false;
            });
    } catch (e, s) {
      logger.error(
        'fetchMoreLoops error',
        error: e,
        stackTrace: s,
      );
      // emit(_copyWith(loopStatus: LoopsStatus.failure));
    } finally {
      await trace.stop();
    }
  }

  void _onScroll() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      if (_isBottom) _fetchMoreLoops();
    });
  }

  @override
  void initState() {
    super.initState();
    _databaseRepository = context.read<DatabaseRepository>();
    _scrollController.addListener(_onScroll);
    _initLoops();
  }

  Widget _buildUserLoopFeed(UserModel user) => switch (_loopStatus) {
        LoopsStatus.initial => const Text('Waiting for New Loops...'),
        LoopsStatus.failure => const Center(
            child: Text('failed to fetch loops'),
          ),
        LoopsStatus.success => () {
            if (_userLoops.isEmpty || user.deleted) {
              return const Text('No loops yet...');
            }

            return CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  stretch: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.read<NavigationBloc>().add(
                          const Pop(),
                        ),
                  ),
                  title: Text(
                    user.artistName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                    ),
                    overflow: TextOverflow.fade,
                    maxLines: 2,
                  ),
                  centerTitle: false,
                  onStretchTrigger: () async {
                    await _initLoops();
                  },
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverList(
                    // itemExtent: 100,
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return LoopContainer(
                          loop: _userLoops[index],
                        );
                      },
                      childCount: _userLoops.length,
                    ),
                  ),
                ),
              ],
            );
          }(),
      };

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder<Option<UserModel>>(
        future: _databaseRepository.getUserById(_userId),
        builder: (context, snapshot) {
          final user = snapshot.data;
          return switch (user) {
            null => const Center(child: CircularProgressIndicator()),
            None() => const Center(child: Text('User not found')),
            Some(:final value) => _buildUserLoopFeed(value),
          };
        },
      ),
    );
  }
}

enum LoopsStatus {
  initial,
  success,
  failure,
}
