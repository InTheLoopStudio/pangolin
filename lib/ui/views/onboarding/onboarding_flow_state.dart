part of 'onboarding_flow_cubit.dart';

enum OnboardingStage {
  stage1,
  stage2,
}

class OnboardingFlowState extends Equatable {
  OnboardingFlowState({
    required this.currentUser,
    this.onboardingStage = OnboardingStage.stage1,
    this.username = '',
    this.artistName = '',
    this.location = '',
    this.bio = '',
    // this.musicianType = const [],
    this.pickedPhoto,
    this.status = FormzStatus.pure,
    this.loading = false,
    this.followingInfamous = false,
    this.followingJohannes = false,
    this.followingChris = false,
    this.followingIlias = false,
    ImagePicker? picker,
    GlobalKey<FormState>? formKey,
  }) {
    this.picker = picker ?? ImagePicker();
    this.formKey = formKey ?? GlobalKey<FormState>(debugLabel: 'onboarding');
  }

  final UserModel currentUser;
  final bool loading;
  final OnboardingStage onboardingStage;
  final String username;
  final String artistName;
  final String location;
  final String bio;
  // final List<String> musicianType;
  final File? pickedPhoto;
  final FormzStatus status;
  late final ImagePicker picker;
  late final GlobalKey<FormState> formKey;

  final bool followingInfamous;
  final bool followingJohannes;
  final bool followingChris;
  final bool followingIlias;

  @override
  List<Object?> get props => [
        loading,
        onboardingStage,
        username,
        artistName,
        location,
        bio,
        // musicianType,
        pickedPhoto,
        status,
        followingInfamous,
        followingJohannes,
        followingChris,
        followingIlias,
        formKey
      ];

  OnboardingFlowState copyWith({
    bool? loading,
    OnboardingStage? onboardingStage,
    String? username,
    String? artistName,
    String? location,
    String? bio,
    // List<String>? musicianType,
    File? pickedPhoto,
    FormzStatus? status,
    bool? followingInfamous,
    bool? followingJohannes,
    bool? followingChris,
    bool? followingIlias,
  }) {
    return OnboardingFlowState(
      currentUser: currentUser,
      loading: loading ?? this.loading,
      onboardingStage: onboardingStage ?? this.onboardingStage,
      username: username ?? this.username,
      artistName: artistName ?? this.artistName,
      location: location ?? this.location,
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
