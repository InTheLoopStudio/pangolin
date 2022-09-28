import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/common/loading/loading_view.dart';
import 'package:intheloopapp/ui/views/onboarding/onboarding_cubit.dart';
import 'package:intheloopapp/ui/widgets/onboarding/stage1/stage1.dart';
import 'package:intheloopapp/ui/widgets/onboarding/stage2/stage2.dart';

class OnboardingForm extends StatelessWidget {
  const OnboardingForm({Key? key}) : super(key: key);

  Widget currentStageView(OnboardingStage stage) {
    if (stage == OnboardingStage.stage1) {
      return const Stage1();
    } else if (stage == OnboardingStage.stage2) {
      return const Stage2();
    } else {
      return const Stage1();
    }
  }

  bool reverseTransition(OnboardingStage stage) {
    if (stage == OnboardingStage.stage1) {
      return true;
    } else if (stage == OnboardingStage.stage2) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return PageTransitionSwitcher(
          duration: const Duration(milliseconds: 500),
          reverse: reverseTransition(state.onboardingStage),
          transitionBuilder: (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
          child: state.loading
              ? const LoadingView()
              : currentStageView(state.onboardingStage),
        );
      },
    );
  }
}
