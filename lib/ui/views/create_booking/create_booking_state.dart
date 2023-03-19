part of 'create_booking_cubit.dart';

class CreateBookingState extends Equatable with FormzMixin {
  CreateBookingState({
    required this.currentUserId,
    required this.requesteeId,
    this.name = const BookingName.pure(),
    this.note = const BookingNote.pure(),
    this.status = FormzSubmissionStatus.initial,
    BookingStartTime? startTime,
    BookingEndTime? endTime,
    GlobalKey<FormState>? formKey,
  }) {
    this.startTime = startTime ?? BookingStartTime.pure();
    this.endTime = endTime ?? BookingEndTime.pure();
    this.formKey = formKey ?? GlobalKey<FormState>(debugLabel: 'settings');
  }

  final BookingName name;
  final BookingNote note;
  final String currentUserId;
  final String requesteeId;
  final FormzSubmissionStatus status;
  late final BookingStartTime startTime;
  late final BookingEndTime endTime;
  late final GlobalKey<FormState> formKey;

  @override
  List<Object?> get props => [
        currentUserId,
        requesteeId,
        name,
        note,
        status,
        startTime,
        endTime,
        formKey,
      ];

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [
        name,
        note,
        startTime,
        endTime,
      ];

  CreateBookingState copyWith({
    String? currentUserId,
    String? requesteeId,
    BookingName? name,
    BookingNote? note,
    BookingStartTime? startTime,
    BookingEndTime? endTime,
    FormzSubmissionStatus? status,
  }) {
    return CreateBookingState(
      formKey: formKey,
      currentUserId: currentUserId ?? this.currentUserId,
      requesteeId: requesteeId ?? this.requesteeId,
      name: name ?? this.name,
      note: note ?? this.note,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
    );
  }

  String get formattedStartTime {
    final outputFormat = DateFormat('MM/dd/yyyy HH:mm');
    final outputDate = outputFormat.format(startTime.value);
    return outputDate;
  }

  String get formattedEndTime {
    final outputFormat = DateFormat('MM/dd/yyyy HH:mm');
    final outputDate = outputFormat.format(endTime.value);
    return outputDate;
  }

  String get formattedDuration {
    final d = endTime.value.difference(startTime.value);
    return d.toString().split('.').first.padLeft(8, '0');
  }
}
