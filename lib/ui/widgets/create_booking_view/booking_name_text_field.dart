import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/create_booking/create_booking_cubit.dart';

class BookingNameTextField extends StatelessWidget {
  const BookingNameTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBookingCubit, CreateBookingState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: '',
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.event),
            labelText: 'Event Name (optional)',
            hintText: 'Something in the Water',
          ),
          onChanged: (input) =>
              context.read<CreateBookingCubit>().updateName(input),
        );
      },
    );
  }
}
