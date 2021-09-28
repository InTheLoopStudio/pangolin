part of 'onboarding_cubit.dart';

enum OnboardingStage {
  stage1,
  stage2,
}

class OnboardingState extends Equatable {
  OnboardingState({
    required this.currentUser,
    this.onboardingStage = OnboardingStage.stage1,
    this.username = '',
    this.location = '',
    this.bio = '',
    // this.musicianType = const [],
    this.pickedPhoto,
    this.loading = false,
    this.followingInTheLoop = false,
    this.followingJohannes = false,
    this.followingChris = false,
    this.followingSohail = false,
    ImagePicker? picker,
  }) {
    this.picker = picker ?? ImagePicker();
  }

  final UserModel currentUser;
  final bool loading;
  final OnboardingStage onboardingStage;
  final String username;
  final String location;
  final String bio;
  // final List<String> musicianType;
  final File? pickedPhoto;
  late final ImagePicker picker;

  final bool followingInTheLoop;
  final bool followingJohannes;
  final bool followingChris;
  final bool followingSohail;

  @override
  List<Object?> get props => [
        loading,
        onboardingStage,
        username,
        location,
        bio,
        // musicianType,
        pickedPhoto,
        followingInTheLoop,
        followingJohannes,
        followingChris,
        followingSohail,
      ];

  OnboardingState copyWith({
    bool? loading,
    OnboardingStage? onboardingStage,
    String? username,
    String? location,
    String? bio,
    // List<String>? musicianType,
    File? pickedPhoto,
    bool? followingInTheLoop,
    bool? followingJohannes,
    bool? followingChris,
    bool? followingSohail,
  }) {
    return OnboardingState(
      currentUser: currentUser,
      loading: loading ?? this.loading,
      onboardingStage: onboardingStage ?? this.onboardingStage,
      username: username ?? this.username,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      // musicianType: musicianType ?? this.musicianType,
      pickedPhoto: pickedPhoto ?? this.pickedPhoto,
      picker: picker,
      followingInTheLoop: followingInTheLoop ?? this.followingInTheLoop,
      followingJohannes: followingJohannes ?? this.followingJohannes,
      followingChris: followingChris ?? this.followingChris,
      followingSohail: followingSohail ?? this.followingSohail,
    );
  }
}
