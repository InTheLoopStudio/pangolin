import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/create_booking/create_booking_cubit.dart';

class BookingNoteTextField extends StatelessWidget {
  const BookingNoteTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBookingCubit, CreateBookingState>(
      builder: (context, state) {
        return TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Add a booking note for the band',
          ),
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          maxLines: 10,
          onChanged: (input) =>
              context.read<CreateBookingCubit>().updateNote(input),
        );
      },
    );
  }
}
