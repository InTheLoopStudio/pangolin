part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  SettingsState({
    this.username = '',
    this.artistName = '',
    this.bio = '',
    this.genres = const [],
    this.label,
    this.occupations = const [],
    this.placeId,
    this.twitterHandle,
    this.instagramHandle,
    this.soundcloudHandle,
    this.tiktokHandle,
    this.youtubeChannelId,
    this.profileImage,
    this.status = FormzSubmissionStatus.initial,
    this.pushNotificationsLikes = true,
    this.pushNotificationsComments = true,
    this.pushNotificationsFollows = true,
    this.pushNotificationsDirectMessages = true,
    this.pushNotificationsITLUpdates = true,
    this.emailNotificationsAppReleases = true,
    this.emailNotificationsITLUpdates = true,
    this.email = '',
    this.password = '',
    this.rate = 0,
    Place? place,
    ImagePicker? picker,
    GlobalKey<FormState>? formKey,
  }) {
    this.picker = picker ?? ImagePicker();
    this.formKey = formKey ?? GlobalKey<FormState>(debugLabel: 'settings');
    this.place = place ?? const Place();
  }

  final String username;
  final String artistName;
  final List<Genre> genres;
  final List<String> occupations;
  final String? label;

  final String bio;

  final String? twitterHandle;
  final String? instagramHandle;
  final String? soundcloudHandle;
  final String? tiktokHandle;
  final String? youtubeChannelId;
  final File? profileImage;
  final FormzSubmissionStatus status;

  final String? placeId;
  late final Place? place;

  late final ImagePicker picker;
  late final GlobalKey<FormState> formKey;

  final bool pushNotificationsLikes;
  final bool pushNotificationsComments;
  final bool pushNotificationsFollows;
  final bool pushNotificationsDirectMessages;
  final bool pushNotificationsITLUpdates;
  final bool emailNotificationsAppReleases;
  final bool emailNotificationsITLUpdates;

  final String email;
  final String password;

  final int rate;

  @override
  List<Object?> get props => [
        username,
        artistName,
        bio,
        genres,
        label,
        occupations,
        place,
        placeId,
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
        email,
        password,
        rate,
      ];

  SettingsState copyWith({
    String? username,
    String? artistName,
    String? bio,
    List<Genre>? genres,
    List<String>? occupations,
    String? label,
    Place? place,
    String? placeId,
    String? twitterHandle,
    String? instagramHandle,
    String? tiktokHandle,
    String? soundcloudHandle,
    String? youtubeChannelId,
    File? profileImage,
    FormzSubmissionStatus? status,
    bool? pushNotificationsLikes,
    bool? pushNotificationsComments,
    bool? pushNotificationsFollows,
    bool? pushNotificationsDirectMessages,
    bool? pushNotificationsITLUpdates,
    bool? emailNotificationsAppReleases,
    bool? emailNotificationsITLUpdates,
    String? email,
    String? password,
    int? rate,
  }) {
    return SettingsState(
      username: username ?? this.username,
      artistName: artistName ?? this.artistName,
      bio: bio ?? this.bio,
      genres: genres ?? this.genres,
      occupations: occupations ?? this.occupations,
      label: label ?? this.label,
      place: place ?? this.place,
      placeId: placeId ?? this.placeId,
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
      email: email ?? this.email,
      password: password ?? this.password,
      rate: rate ?? this.rate,
    );
  }
}
