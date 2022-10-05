part of './send_badge_cubit.dart';

class SendBadgeState extends Equatable {
  SendBadgeState({
    this.badgeImage,
    this.badgeName = '',
    this.badgeDescription = '',
    this.receiverUsername = '',
    this.status = FormzStatus.pure,
    GlobalKey<FormState>? formKey,
    ImagePicker? picker,
  }) {
    this.picker = picker ?? ImagePicker();
    this.formKey = formKey ?? GlobalKey<FormState>(debugLabel: 'send_badge');
  }

  final File? badgeImage;
  final String badgeName;
  final String badgeDescription;
  final String receiverUsername;

  late final ImagePicker picker;
  late final GlobalKey<FormState> formKey;
  final FormzStatus status;

  @override
  List<Object?> get props => [
        badgeImage,
        badgeName,
        badgeDescription,
        receiverUsername,
        status,
      ];

  SendBadgeState copyWith({
    File? badgeImage,
    String? badgeName,
    String? badgeDescription,
    String? receiverUsername,
    FormzStatus? status,
  }) {
    return SendBadgeState(
      badgeImage: badgeImage ?? this.badgeImage,
      badgeName: badgeName ?? this.badgeName,
      badgeDescription: badgeDescription ?? this.badgeDescription,
      receiverUsername: receiverUsername ?? this.receiverUsername,
      status: status ?? this.status,
      formKey: formKey,
      picker: picker,
    );
  }
}
