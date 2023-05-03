import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/ui/views/create_service/create_service_cubit.dart';

class RateTypeSelector extends StatelessWidget {
  const RateTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateServiceCubit, CreateServiceState>(
      builder: (context, state) {
        return SegmentedButton<RateType>(
          segments: const [
            ButtonSegment(
              icon: Icon(CupertinoIcons.clock),
              value: RateType.hourly,
              label: Text('hourly'),
            ),
            ButtonSegment(
              icon: Icon(CupertinoIcons.money_dollar),
              value: RateType.fixed,
              label: Text('fixed'),
            ),
          ],
          selected: {state.rateType},
          onSelectionChanged: (p0) =>
              context.read<CreateServiceCubit>().onRateTypeChange(p0.first),
        );
      },
    );
  }
}
