part of 'create_booking_cubit.dart';

class CreateBookingState extends Equatable with FormzMixin {
  CreateBookingState({
    required this.currentUserId,
    required this.requesteeId,
    required this.requesteeBookingRate,
    required this.bookingFee,
    this.name = const BookingName.pure(),
    this.note = const BookingNote.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.place = const None(),
    this.placeId = const None(),
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
  final int requesteeBookingRate;
  final double bookingFee;
  final FormzSubmissionStatus status;
  late final BookingStartTime startTime;
  late final BookingEndTime endTime;
  late final GlobalKey<FormState> formKey;

  final Option<Place> place;
  final Option<String> placeId;

  @override
  List<Object?> get props => [
        currentUserId,
        requesteeId,
        requesteeBookingRate,
        bookingFee,
        name,
        note,
        status,
        startTime,
        endTime,
        formKey,
        place,
        placeId,
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
    int? requesteeBookingRate,
    double? bookingFee,
    BookingName? name,
    BookingNote? note,
    BookingStartTime? startTime,
    BookingEndTime? endTime,
    FormzSubmissionStatus? status,
    Option<Place>? place,
    Option<String>? placeId,
  }) {
    return CreateBookingState(
      formKey: formKey,
      currentUserId: currentUserId ?? this.currentUserId,
      requesteeId: requesteeId ?? this.requesteeId,
      requesteeBookingRate: requesteeBookingRate ?? this.requesteeBookingRate,
      bookingFee: bookingFee ?? this.bookingFee,
      name: name ?? this.name,
      note: note ?? this.note,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      place: place ?? this.place,
      placeId: placeId ?? this.placeId,
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

  int get artistCost {
    final d = endTime.value.difference(startTime.value);
    final rateInMinutes = requesteeBookingRate / 60;
    final total = d.inMinutes * rateInMinutes;

    return total.toInt();
  }

  int get applicationFee {
    final total = artistCost;
    final fee = (total * bookingFee).toInt();
    return fee;
  }

  int get totalCost {
    final total = artistCost + applicationFee;
    return total;
  }

  String get formattedApplicationFee {
    final fee = applicationFee / 100;
    return '\$${fee.toStringAsFixed(2)}';
  }

  String get formattedArtistRate {
    final rate = artistCost / 100;
    return '\$${rate.toStringAsFixed(2)}';
  }

  String get formattedTotal {
    final total = totalCost / 100;
    return '\$${total.toStringAsFixed(2)}';
  }
}
