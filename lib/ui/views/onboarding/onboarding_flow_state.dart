part of 'onboarding_flow_cubit.dart';

enum OnboardingStage {
  stage1,
  stage2,
}

class OnboardingFlowState extends Equatable {
  OnboardingFlowState({
    required this.currentUserId,
    this.onboardingStage = OnboardingStage.stage1,
    this.username = '',
    this.artistName = '',
    this.placeId = rvaPlaceId,
    this.bio = '',
    // this.musicianType = const [],
    this.pickedPhoto,
    this.status = FormzSubmissionStatus.initial,
    this.loading = false,
    this.followingInfamous = false,
    this.followingJohannes = false,
    this.followingChris = false,
    this.followingIlias = false,
    Place? place,
    ImagePicker? picker,
    GlobalKey<FormState>? formKey,
  }) {
    this.picker = picker ?? ImagePicker();
    this.formKey = formKey ?? GlobalKey<FormState>(debugLabel: 'onboarding');
    this.place = place ??
        const Place(
          latLng: LatLng(
            lat: rvaLat,
            lng: rvaLng,
          ),
        );
  }

  final String currentUserId;
  final bool loading;
  final OnboardingStage onboardingStage;
  final String username;
  final String artistName;
  final String placeId;
  final String bio;
  // final List<String> musicianType;
  final File? pickedPhoto;
  final FormzSubmissionStatus status;
  late final ImagePicker picker;
  late final GlobalKey<FormState> formKey;
  late final Place place;

  final bool followingInfamous;
  final bool followingJohannes;
  final bool followingChris;
  final bool followingIlias;

  @override
  List<Object?> get props => [
        currentUserId,
        loading,
        onboardingStage,
        username,
        artistName,
        placeId,
        place,
        bio,
        // musicianType,
        pickedPhoto,
        status,
        followingInfamous,
        followingJohannes,
        followingChris,
        followingIlias,
        formKey,
      ];

  OnboardingFlowState copyWith({
    bool? loading,
    OnboardingStage? onboardingStage,
    String? username,
    String? artistName,
    String? placeId,
    Place? place,
    String? bio,
    // List<String>? musicianType,
    File? pickedPhoto,
    FormzSubmissionStatus? status,
    bool? followingInfamous,
    bool? followingJohannes,
    bool? followingChris,
    bool? followingIlias,
  }) {
    return OnboardingFlowState(
      currentUserId: currentUserId,
      loading: loading ?? this.loading,
      onboardingStage: onboardingStage ?? this.onboardingStage,
      username: username ?? this.username,
      artistName: artistName ?? this.artistName,
      placeId: placeId ?? this.placeId,
      place: place ?? this.place,
      bio: bio ?? this.bio,
      // musicianType: musicianType ?? this.musicianType,
      pickedPhoto: pickedPhoto ?? this.pickedPhoto,
      status: status ?? this.status,
      picker: picker,
      followingInfamous: followingInfamous ?? this.followingInfamous,
      followingJohannes: followingJohannes ?? this.followingJohannes,
      followingChris: followingChris ?? this.followingChris,
      followingIlias: followingIlias ?? this.followingIlias,
      formKey: formKey,
    );
  }
}
