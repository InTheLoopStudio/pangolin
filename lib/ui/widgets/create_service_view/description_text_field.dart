import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/create_service/create_service_cubit.dart';

class DescriptionTextField extends StatelessWidget {
  const DescriptionTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateServiceCubit, CreateServiceState>(
      builder: (context, state) {
        return TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: const InputDecoration.collapsed(
            hintText: 'Describe the service...',
          ),
          style: const TextStyle(
            letterSpacing: 0,
          ),
          maxLength: 1024,
          minLines: 12,
          initialValue: state.description,
          validator: (value) =>
              value!.isEmpty ? 'Description cannot be empty' : null,
          onChanged: (input) =>
              context.read<CreateServiceCubit>().onDescriptionChange(
                    input.trim(),
                  ),
        );
      },
    );
  }
}
