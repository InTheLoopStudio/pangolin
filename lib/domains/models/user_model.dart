import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/domains/models/genre.dart';
import 'package:intheloopapp/domains/models/username.dart';
import 'package:intheloopapp/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// The different account types for a user
enum AccountType {
  /// Venue users
  @JsonValue('venue')
  venue,

  /// Users with free accounts
  @JsonValue('free')
  free,
}

@JsonSerializable()
class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.artistName,
    required this.profilePicture,
    required this.bio,
    required this.genres,
    required this.occupations,
    required this.label,
    required this.placeId,
    required this.geohash,
    required this.lat,
    required this.lng,
    required this.loopsCount,
    required this.badgesCount,
    required this.deleted,
    required this.shadowBanned,
    required this.accountType,
    required this.youtubeChannelId,
    required this.soundcloudHandle,
    required this.tiktokHandle,
    required this.instagramHandle,
    required this.twitterHandle,
    required this.pushNotificationsLikes,
    required this.pushNotificationsComments,
    required this.pushNotificationsFollows,
    required this.pushNotificationsDirectMessages,
    required this.pushNotificationsITLUpdates,
    required this.emailNotificationsAppReleases,
    required this.emailNotificationsITLUpdates,
    required this.bookingRate,
    required this.stripeConnectedAccountId,
    required this.stripeCustomerId,
  });

  factory UserModel.empty() => UserModel(
        id: '',
        email: '',
        username: Username.fromString('anonymous'),
        artistName: '',
        bio: '',
        genres: const [],
        occupations: const [],
        label: 'None',
        profilePicture: null,
        placeId: null,
        geohash: null,
        lat: null,
        lng: null,
        loopsCount: 0,
        badgesCount: 0,
        deleted: false,
        shadowBanned: false,
        accountType: AccountType.free,
        youtubeChannelId: null,
        soundcloudHandle: null,
        tiktokHandle: null,
        instagramHandle: null,
        twitterHandle: null,
        pushNotificationsLikes: true,
        pushNotificationsComments: true,
        pushNotificationsFollows: true,
        pushNotificationsDirectMessages: true,
        pushNotificationsITLUpdates: true,
        emailNotificationsAppReleases: true,
        emailNotificationsITLUpdates: true,
        bookingRate: 0,
        stripeConnectedAccountId: null,
        stripeCustomerId: null,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    late final AccountType accountType;
    try {
      accountType = $enumDecode(
        _$AccountTypeEnumMap,
        doc.getOrElse('accountType', 'free'),
      );
    } on Exception {
      accountType = AccountType.free;
    }

    return UserModel(
      id: doc.id,
      email: doc.getOrElse('email', '') as String,
      username:
          Username.fromString(doc.getOrElse('username', 'anonymous') as String),
      artistName: doc.getOrElse('artistName', '') as String,
      profilePicture: doc.getOrElse('profilePicture', null) as String?,
      bio: doc.getOrElse('bio', '') as String,
      genres: (doc.getOrElse('genres', <dynamic>[]) as List<dynamic>)
          .map(
            (dynamic e) =>
                EnumToString.fromString<Genre>(Genre.values, e as String),
          )
          .where((element) => element != null)
          .whereType<Genre>()
          .toList(),
      occupations: (doc.getOrElse('occupations', <dynamic>[]) as List<dynamic>)
          .whereType<String>()
          .toList(),
      label: doc.getOrElse('label', 'None') as String,
      placeId: doc.getOrElse('placeId', null) as String?,
      geohash: doc.getOrElse('geohash', null) as String?,
      lat: doc.getOrElse('lat', null) as double?,
      lng: doc.getOrElse('lng', null) as double?,
      loopsCount: doc.getOrElse('loopsCount', 0) as int,
      badgesCount: doc.getOrElse('badgesCount', 0) as int,
      deleted: doc.getOrElse('deleted', false) as bool,
      shadowBanned: doc.getOrElse('shadowBanned', false) as bool,
      accountType: accountType,
      youtubeChannelId: doc.getOrElse('youtubeChannelId', null) as String?,
      soundcloudHandle: doc.getOrElse('soundcloudHandle', null) as String?,
      tiktokHandle: doc.getOrElse('tiktokHandle', null) as String?,
      instagramHandle: doc.getOrElse('instagramHandle', null) as String?,
      twitterHandle: doc.getOrElse('twitterHandle', null) as String?,
      pushNotificationsLikes:
          doc.getOrElse('pushNotificationsLikes', true) as bool,
      pushNotificationsComments:
          doc.getOrElse('pushNotificationsComments', true) as bool,
      pushNotificationsFollows:
          doc.getOrElse('pushNotificationsFollows', true) as bool,
      pushNotificationsDirectMessages:
          doc.getOrElse('pushNotificationsDirectMessages', true) as bool,
      pushNotificationsITLUpdates:
          doc.getOrElse('pushNotificationsITLUpdates', true) as bool,
      emailNotificationsAppReleases:
          doc.getOrElse('emailNotificationsAppReleases', true) as bool,
      emailNotificationsITLUpdates:
          doc.getOrElse('emailNotificationsITLUpdates', true) as bool,
      bookingRate: doc.getOrElse('bookingRate', 0) as int,
      stripeConnectedAccountId: doc.getOrElse(
        'stripeConnectedAccountId',
        null,
      ) as String?,
      stripeCustomerId: doc.getOrElse('stripeCustomerId', null) as String?,
    );
  }
  final String id;
  final String email;
  final Username username;
  final String artistName;
  final String bio;
  final List<Genre> genres;
  final List<String> occupations;
  final String label;

  final String? profilePicture;

  final String? placeId;
  final String? geohash;
  final double? lat;
  final double? lng;

  final int loopsCount;
  final int badgesCount;
  final bool deleted;
  final bool shadowBanned;
  final AccountType accountType;

  final String? youtubeChannelId;
  final String? soundcloudHandle;
  final String? tiktokHandle;
  final String? instagramHandle;
  final String? twitterHandle;

  final bool pushNotificationsLikes;
  final bool pushNotificationsComments;
  final bool pushNotificationsFollows;
  final bool pushNotificationsDirectMessages;
  final bool pushNotificationsITLUpdates;

  final bool emailNotificationsAppReleases;
  final bool emailNotificationsITLUpdates;

  // booking rate in cents (USD)
  final int bookingRate;
  final String? stripeConnectedAccountId;
  final String? stripeCustomerId;

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        artistName,
        profilePicture,
        bio,
        genres,
        occupations,
        label,
        placeId,
        geohash,
        lat,
        lng,
        loopsCount,
        badgesCount,
        deleted,
        shadowBanned,
        accountType,
        youtubeChannelId,
        soundcloudHandle,
        tiktokHandle,
        instagramHandle,
        twitterHandle,
        pushNotificationsLikes,
        pushNotificationsComments,
        pushNotificationsFollows,
        pushNotificationsDirectMessages,
        pushNotificationsITLUpdates,
        emailNotificationsAppReleases,
        emailNotificationsITLUpdates,
        bookingRate,
        stripeConnectedAccountId,
        stripeCustomerId,
      ];
  bool get isEmpty => this == UserModel.empty();
  bool get isNotEmpty => this != UserModel.empty();
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  bool get isVenue => accountType == AccountType.venue;
  bool get isNotVenue => accountType != AccountType.venue;
  bool get isFree => accountType == AccountType.free;
  bool get isNotFree => accountType != AccountType.free;

  String get displayName => artistName.isEmpty ? username.username : artistName;

  UserModel copyWith({
    String? id,
    String? email,
    Username? username,
    String? artistName,
    String? profilePicture,
    String? bio,
    List<Genre>? genres,
    List<String>? occupations,
    String? label,
    Option<String>? placeId,
    Option<String>? geohash,
    Option<double>? lat,
    Option<double>? lng,
    int? loopsCount,
    int? badgesCount,
    bool? deleted,
    bool? shadowBanned,
    AccountType? accountType,
    String? youtubeChannelId,
    String? soundcloudHandle,
    String? tiktokHandle,
    String? instagramHandle,
    String? twitterHandle,
    bool? pushNotificationsLikes,
    bool? pushNotificationsComments,
    bool? pushNotificationsFollows,
    bool? pushNotificationsDirectMessages,
    bool? pushNotificationsITLUpdates,
    bool? emailNotificationsAppReleases,
    bool? emailNotificationsITLUpdates,
    int? bookingRate,
    String? stripeConnectedAccountId,
    String? stripeCustomerId,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      artistName: artistName ?? this.artistName,
      profilePicture: profilePicture ?? this.profilePicture,
      bio: bio ?? this.bio,
      genres: genres ?? this.genres,
      occupations: occupations ?? this.occupations,
      label: label ?? this.label,
      placeId: placeId != null ? placeId.value : this.placeId,
      geohash: geohash != null ? geohash.value : this.geohash,
      lat: lat != null ? lat.value : this.lat,
      lng: lng != null ? lng.value : this.lng,
      loopsCount: loopsCount ?? this.loopsCount,
      badgesCount: badgesCount ?? this.badgesCount,
      deleted: deleted ?? this.deleted,
      shadowBanned: shadowBanned ?? this.shadowBanned,
      accountType: accountType ?? this.accountType,
      youtubeChannelId: youtubeChannelId ?? this.youtubeChannelId,
      soundcloudHandle: soundcloudHandle ?? this.soundcloudHandle,
      tiktokHandle: tiktokHandle ?? this.tiktokHandle,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      twitterHandle: twitterHandle ?? this.twitterHandle,
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
      bookingRate: bookingRate ?? this.bookingRate,
      stripeConnectedAccountId:
          stripeConnectedAccountId ?? this.stripeConnectedAccountId,
      stripeCustomerId: stripeCustomerId ?? this.stripeCustomerId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username.toString(),
      'artistName': artistName,
      'bio': bio,
      'genres': genres.map((e) => e.name).toList(),
      'occupations': occupations,
      'label': label,
      'profilePicture': profilePicture,
      'placeId': placeId,
      'geohash': geohash,
      'lat': lat,
      'lng': lng,
      'loopsCount': loopsCount,
      'badgesCount': badgesCount,
      'deleted': deleted,
      'shadowBanned': shadowBanned,
      'accountType': _$AccountTypeEnumMap[accountType],
      'youtubeChannelId': youtubeChannelId,
      'soundcloudHandle': soundcloudHandle,
      'tiktokHandle': tiktokHandle,
      'instagramHandle': instagramHandle,
      'twitterHandle': twitterHandle,
      'pushNotificationsLikes': pushNotificationsLikes,
      'pushNotificationsComments': pushNotificationsComments,
      'pushNotificationsFollows': pushNotificationsFollows,
      'pushNotificationsDirectMessages': pushNotificationsDirectMessages,
      'pushNotificationsITLUpdates': pushNotificationsITLUpdates,
      'emailNotificationsAppReleases': emailNotificationsAppReleases,
      'emailNotificationsITLUpdates': emailNotificationsITLUpdates,
      'bookingRate': bookingRate,
      'stripeConnectedAccountId': stripeConnectedAccountId,
      'stripeCustomerId': stripeCustomerId,
    };
  }
}
