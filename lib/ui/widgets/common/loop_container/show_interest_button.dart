import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';

class ShowInterestButton extends StatefulWidget {
  const ShowInterestButton({
    required this.loop,
    super.key,
  });

  final Loop loop;

  @override
  State<ShowInterestButton> createState() => _ShowInterestButtonState();
}

class _ShowInterestButtonState extends State<ShowInterestButton> {
  bool _isInterested = false;

  @override
  void initState() {
    super.initState();
    initInterested().then((value) => _isInterested = value).whenComplete(() {
      setState(() {});
    });
  }

  Future<bool> initInterested() async {
    try {
      final databaseRepository =
          RepositoryProvider.of<DatabaseRepository>(context);
      final onboardingBloc = RepositoryProvider.of<OnboardingBloc>(context);

      if (onboardingBloc.state is! Onboarded) {
        return false;
      }

      final currentUserId = (onboardingBloc.state as Onboarded).currentUser.id;

      final isInterested = await databaseRepository.isInterested(
        userId: currentUserId,
        loopId: widget.loop.id,
      );

      return isInterested;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = context.read<DatabaseRepository>();

    if (!widget.loop.isOpportunity) {
      return const SizedBox.shrink();
    }

    return BlocSelector<OnboardingBloc, OnboardingState, UserModel?>(
      selector: (state) => state is Onboarded ? state.currentUser : null,
      builder: (context, currentUser) {
        if (currentUser == null) {
          return const SizedBox.shrink();
        }

        if (widget.loop.userId == currentUser.id) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton(
                onPressed: () {
                  context.read<NavigationBloc>().add(
                        PushInterestedView(
                          loop: widget.loop,
                        ),
                      );
                },
                child: const Text("See who's interested"),
              ),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FilledButton(
              onPressed: () {
                _isInterested
                    ? database.cancelInterest(
                        userId: currentUser.id,
                        loopId: widget.loop.id,
                      )
                    : database.showInterest(
                        userId: currentUser.id,
                        loopId: widget.loop.id,
                      );
                setState(() {
                  _isInterested = !_isInterested;
                });
              },
              child: _isInterested
                  ? const Text('Interested')
                  : const Text('Show Interest'),
            ),
          ],
        );
      },
    );
  }
}
