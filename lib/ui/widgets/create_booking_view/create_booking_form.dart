import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/create_booking/create_booking_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/forms/location_text_field.dart';
import 'package:intheloopapp/ui/widgets/create_booking_view/booking_name_text_field.dart';
import 'package:intheloopapp/ui/widgets/create_booking_view/booking_note_text_field.dart';

class CreateBookingForm extends StatefulWidget {
  const CreateBookingForm({super.key});

  @override
  State<CreateBookingForm> createState() => _CreateBookingFormState();
}

class _CreateBookingFormState extends State<CreateBookingForm> {
  // This function displays a CupertinoModalPopup with a reasonable fixed height
  void _showDialog(BuildContext context, Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  final bookingNameController = TextEditingController();
  final noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBookingCubit, CreateBookingState>(
      builder: (context, state) {
        return Form(
          key: state.formKey,
          child: Column(
            children: [
              BookingNameTextField(
                controller: bookingNameController,
              ),
              LocationTextField(
                initialPlaceId: null,
                initialPlace: null,
                onChanged: (place, placeId) {},
              ),
              _FormItem(
                children: [
                  const Text('Start Time'),
                  CupertinoButton(
                    onPressed: () => _showDialog(
                      context,
                      CupertinoDatePicker(
                        initialDateTime: state.startTime.value,
                        minimumDate: DateTime.now().subtract(
                          const Duration(hours: 1),
                        ),
                        use24hFormat: true,
                        onDateTimeChanged: (DateTime newDateTime) {
                          context
                              .read<CreateBookingCubit>()
                              .updateStartTime(newDateTime);
                        },
                      ),
                    ),
                    child: Text(
                      state.formattedStartTime,
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ),
              _FormItem(
                children: <Widget>[
                  const Text('End Time'),
                  CupertinoButton(
                    onPressed: () => _showDialog(
                      context,
                      CupertinoDatePicker(
                        initialDateTime: state.endTime.value,
                        minimumDate: state.startTime.value,
                        use24hFormat: true,
                        onDateTimeChanged: (DateTime newDateTime) {
                          context
                              .read<CreateBookingCubit>()
                              .updateEndTime(newDateTime);
                        },
                      ),
                    ),
                    child: Text(
                      state.formattedEndTime,
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ),
              _FormItem(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 22),
                    child: Text('Duration'),
                  ),
                  Text(
                    state.formattedDuration,
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              _FormItem(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    child: Text(
                      // ignore: lines_longer_than_80_chars
                      'Artist Rate (\$${(state.requesteeBookingRate / 100).toStringAsFixed(2)})',
                    ),
                  ),
                  Text(
                    state.formattedArtistRate,
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              _FormItem(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    child: Text('Booking Fee (${state.bookingFee * 100}%)'),
                  ),
                  Text(
                    state.formattedApplicationFee,
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              _FormItem(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 22),
                    child: Text('Total'),
                  ),
                  Text(
                    state.formattedTotal,
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              BookingNoteTextField(
                controller: noteController,
              ),
            ],
          ),
        );
      },
    );
  }
}

// This class simply decorates a row of widgets.
class _FormItem extends StatelessWidget {
  const _FormItem({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0,
          ),
          bottom: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}
