import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class EPKButton extends StatelessWidget {
  const EPKButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return switch (state.visitedUser.epkUrl) {
          None() => const SizedBox.shrink(),
          Some(:final value) => FilledButton(
              child: const Text('View EPK'),
              onPressed: () async {
                await launchUrl(Uri.parse(value));
              },
            ),
        };
      },
    );
  }
}
