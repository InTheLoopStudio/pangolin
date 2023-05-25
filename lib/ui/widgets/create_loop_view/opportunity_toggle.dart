import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/create_loop/cubit/create_loop_cubit.dart';

class OpportunityToggle extends StatelessWidget {
  const OpportunityToggle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateLoopCubit, CreateLoopState>(
      builder: (context, state) {
        return Row(
          children: [
            const Text(
              'Mark as Opportunity',
            ),
            Checkbox(
              value: state.isOpportunity,
              onChanged: (bool? value) {
                context.read<CreateLoopCubit>().toggleOpportunity();
              },
            ),
          ],
        );
      },
    );
  }
}
