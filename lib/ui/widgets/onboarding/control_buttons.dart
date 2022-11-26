import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/onboarding/onboarding_flow_cubit.dart';

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
        child: const CircularProgressIndicator(),
        onPressed: () {},
      );
    }

    if (stage == OnboardingStage.stage1) {
      return ElevatedButton(
        onPressed: onNext,
        child: const Text('Next'),
      );
    } else if (stage == OnboardingStage.stage2) {
      return ElevatedButton(
        onPressed: onFinish,
        child: const Text('Finish'),
      );
    } else {
      return ElevatedButton(
        onPressed: onNext,
        child: const Text('Next'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
      builder: (context, state) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (state.onboardingStage != OnboardingStage.stage1)
                    TextButton(
                      onPressed: state.onboardingStage == OnboardingStage.stage1
                          ? null
                          : context.read<OnboardingFlowCubit>().previous,
                      child: const Text('Back'),
                    )
                  else
                    const SizedBox.shrink(),
                  _nextStepButton(
                    loading: state.loading,
                    stage: state.onboardingStage,
                    onFinish: () =>
                        context.read<OnboardingFlowCubit>().finishOnboarding(),
                    onNext: () => context.read<OnboardingFlowCubit>().next(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: state.onboardingStage == OnboardingStage.stage1
                          ? tappedAccent
                          : const Color.fromARGB(255, 221, 160, 221),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: state.onboardingStage == OnboardingStage.stage2
                          ? tappedAccent
                          : const Color.fromARGB(255, 221, 160, 221),
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
