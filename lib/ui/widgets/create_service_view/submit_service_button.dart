import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/ui/views/create_service/create_service_cubit.dart';

class SubmitServiceButton extends StatelessWidget {
  const SubmitServiceButton({
    required this.onCreated,
    super.key,
  });

  final void Function(Service) onCreated;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateServiceCubit, CreateServiceState>(
      builder: (context, state) {
        return CupertinoButton.filled(
          onPressed: () {
            try {
              context.read<CreateServiceCubit>().submit(onCreated);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(e.toString()),
                ),
              );
            }
          },
          child: const Text('Create'),
        );
      },
    );
  }
}
