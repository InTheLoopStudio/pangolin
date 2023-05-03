import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/create_service/create_service_cubit.dart';

class TitleTextField extends StatelessWidget {
  const TitleTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateServiceCubit, CreateServiceState>(
      builder: (context, state) {
        return TextFormField(
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          initialValue: state.title,
          decoration: const InputDecoration.collapsed(
            // prefixIcon: Icon(Icons.title),
            // labelText: 'Title (optional)',
            hintText: 'Title',
          ),
          maxLength: 56,
          onChanged: (input) =>
              context.read<CreateServiceCubit>().onTitleChange(
                    input.trim(),
                  ),
        );
      },
    );
  }
}
