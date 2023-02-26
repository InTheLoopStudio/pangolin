import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/onboarding/onboarding_flow_cubit.dart';
import 'package:intheloopapp/ui/widgets/onboarding/stage2/follow_recommendation.dart';

class Stage2 extends StatelessWidget {
  const Stage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
      builder: (context, state) {
        return Align(
          alignment: const Alignment(0, -1 / 3),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 100),
                    Text(
                      'Follow Recommendations',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Johannes
                FollowRecommendation(
                  userId: '8yYVxpQ7cURSzNfBsaBGF7A7kkv2',
                  isFollowing: state.followingJohannes,
                ),
                // Chris Testes
                FollowRecommendation(
                  userId: 'wHpU3xj2yUSuz2rLFKC6J87HTLu1',
                  isFollowing: state.followingChris,
                ),
                // Ilias
                FollowRecommendation(
                  userId: 'n4zIL6bOuPTqRC3dtsl6gyEBPQl1',
                  isFollowing: state.followingIlias,
                ),
                // Infamousg
                FollowRecommendation(
                  userId: 'VWj4qT2JMIhjjEYYFnbvebIazfB3',
                  isFollowing: state.followingInfamous,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
