part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  SettingsState({
    this.username = '',
    this.bio = '',
    this.location = '',
    this.twitterHandle = '',
    this.instagramHandle = '',
    this.soundcloudHandle = '',
    this.tiktokHandle = '',
    this.youtubeChannelId = '',
    this.profileImage,
    this.status = FormzStatus.pure,
    ImagePicker? picker,
    GlobalKey<FormState>? formKey,
  }) {
    this.picker = picker ?? ImagePicker();
    this.formKey = formKey ?? GlobalKey<FormState>();
  }

  final String username;
  final String bio;
  final String location;
  final String twitterHandle;
  final String instagramHandle;
  final String soundcloudHandle;
  final String tiktokHandle;
  final String youtubeChannelId;
  final File? profileImage;
  final FormzStatus status;
  late final ImagePicker picker;
  late final formKey;

  List<Object?> get props => [
        username,
        bio,
        location,
        twitterHandle,
        instagramHandle,
        tiktokHandle,
        soundcloudHandle,
        youtubeChannelId,
        profileImage,
        status,
      ];

  SettingsState copyWith({
    String? username,
    String? bio,
    String? location,
    String? twitterHandle,
    String? instagramHandle,
    String? tiktokHandle,
    String? soundcloudHandle,
    String? youtubeChannelId,
    File? profileImage,
    FormzStatus? status,
  }) {
    return SettingsState(
      username: username ?? this.username,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      twitterHandle: twitterHandle ?? this.twitterHandle,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      tiktokHandle: tiktokHandle ?? this.tiktokHandle,
      soundcloudHandle: soundcloudHandle ?? this.soundcloudHandle,
      youtubeChannelId: youtubeChannelId ?? this.youtubeChannelId,
      profileImage: profileImage ?? this.profileImage,
      status: status ?? this.status,
      picker: this.picker,
      formKey: this.formKey,
    );
  }
}
