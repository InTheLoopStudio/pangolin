import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/onboarding/onboarding_cubit.dart';

class ControlButtons extends StatelessWidget {
  const ControlButtons({Key? key}) : super(key: key);

  Widget _nextStepButton({
    required OnboardingStage stage,
    void Function()? onNext,
    void Function()? onFinish,
    bool loading = false,
  }) {
    if (loading) {
      return ElevatedButton(
        child: CircularProgressIndicator(),
        onPressed: () {},
      );
    }

    if (stage == OnboardingStage.stage1) {
      return ElevatedButton(
        child: Text('Next'),
        onPressed: onNext,
      );
    } else if (stage == OnboardingStage.stage2) {
      return ElevatedButton(
        child: Text('Finish'),
        onPressed: onFinish,
      );
    } else {
      return ElevatedButton(
        child: Text('Next'),
        onPressed: onNext,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  state.onboardingStage != OnboardingStage.stage1
                      ? TextButton(
                          child: Text('Back'),
                          onPressed:
                              state.onboardingStage == OnboardingStage.stage1
                                  ? null
                                  : context.read<OnboardingCubit>().previous,
                        )
                      : SizedBox.shrink(),
                  _nextStepButton(
                    loading: state.loading,
                    stage: state.onboardingStage,
                    onFinish: () =>
                        context.read<OnboardingCubit>().finishOnboarding(),
                    onNext: () => context.read<OnboardingCubit>().next(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: state.onboardingStage == OnboardingStage.stage1
                          ? itlAccent
                          : Color.fromARGB(255, 221, 160, 221),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: state.onboardingStage == OnboardingStage.stage2
                          ? itlAccent
                          : Color.fromARGB(255, 221, 160, 221),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
