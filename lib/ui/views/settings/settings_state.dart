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
    this.pushNotificationsLikes = true,
    this.pushNotificationsComments = true,
    this.pushNotificationsFollows = true,
    this.pushNotificationsDirectMessages = true,
    this.pushNotificationsITLUpdates = true,
    this.emailNotificationsAppReleases = true,
    this.emailNotificationsITLUpdates = true,
    ImagePicker? picker,
    GlobalKey<FormState>? formKey,
  }) {
    this.picker = picker ?? ImagePicker();
    this.formKey = formKey ?? GlobalKey<FormState>(debugLabel: 'settings');
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
  late final GlobalKey<FormState> formKey;

  final bool pushNotificationsLikes;
  final bool pushNotificationsComments;
  final bool pushNotificationsFollows;
  final bool pushNotificationsDirectMessages;
  final bool pushNotificationsITLUpdates;
  final bool emailNotificationsAppReleases;
  final bool emailNotificationsITLUpdates;

  @override
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
        pushNotificationsLikes,
        pushNotificationsComments,
        pushNotificationsFollows,
        pushNotificationsDirectMessages,
        pushNotificationsITLUpdates,
        emailNotificationsAppReleases,
        emailNotificationsITLUpdates,
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
    bool? pushNotificationsLikes,
    bool? pushNotificationsComments,
    bool? pushNotificationsFollows,
    bool? pushNotificationsDirectMessages,
    bool? pushNotificationsITLUpdates,
    bool? emailNotificationsAppReleases,
    bool? emailNotificationsITLUpdates,
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
      pushNotificationsLikes:
          pushNotificationsLikes ?? this.pushNotificationsLikes,
      pushNotificationsComments:
          pushNotificationsComments ?? this.pushNotificationsComments,
      pushNotificationsFollows:
          pushNotificationsFollows ?? this.pushNotificationsFollows,
      pushNotificationsDirectMessages: pushNotificationsDirectMessages ??
          this.pushNotificationsDirectMessages,
      pushNotificationsITLUpdates:
          pushNotificationsITLUpdates ?? this.pushNotificationsITLUpdates,
      emailNotificationsAppReleases:
          emailNotificationsAppReleases ?? this.emailNotificationsAppReleases,
      emailNotificationsITLUpdates:
          emailNotificationsITLUpdates ?? this.emailNotificationsITLUpdates,
      picker: picker,
      formKey: formKey,
    );
  }
}
