import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_container.dart';

class OpportunitySliver extends StatelessWidget {
  const OpportunitySliver({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.userOpportunities.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Text(
                'Latest Opportunity',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            LoopContainer(
              loop: state.userOpportunities.first,
            ),
          ],
        );
      },
    );
  }
}
