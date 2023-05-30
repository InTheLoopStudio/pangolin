part of 'onboarding_flow_cubit.dart';

class OnboardingFlowState extends Equatable with FormzMixin {
  OnboardingFlowState({
    required this.currentUserId,
    this.username = const UsernameInput.pure(),
    this.artistName = const ArtistNameInput.pure(),
    this.bio = const BioInput.pure(),
    this.placeId = const None(),
    // this.musicianType = const [],
    this.pickedPhoto = const None(),
    this.status = FormzSubmissionStatus.initial,
    this.place = const None(),
    ImagePicker? picker,
    GlobalKey<FormState>? formKey,
  }) {
    this.picker = picker ?? ImagePicker();
    this.formKey = formKey ?? GlobalKey<FormState>(debugLabel: 'onboarding');
  }

  final String currentUserId;
  final UsernameInput username;
  final ArtistNameInput artistName;
  final BioInput bio;
  final Option<String> placeId;
  final Option<File> pickedPhoto;

  final FormzSubmissionStatus status;
  late final ImagePicker picker;
  late final GlobalKey<FormState> formKey;
  late final Option<Place> place;

  @override
  List<Object?> get props => [
        currentUserId,
        username,
        artistName,
        placeId,
        place,
        bio,
        pickedPhoto,
        status,
        formKey,
      ];

  OnboardingFlowState copyWith({
    UsernameInput? username,
    ArtistNameInput? artistName,
    BioInput? bio,
    Option<String>? placeId,
    Option<Place>? place,
    Option<File>? pickedPhoto,
    FormzSubmissionStatus? status,
  }) {
    return OnboardingFlowState(
      currentUserId: currentUserId,
      username: username ?? this.username,
      artistName: artistName ?? this.artistName,
      placeId: placeId ?? this.placeId,
      place: place ?? this.place,
      bio: bio ?? this.bio,
      // musicianType: musicianType ?? this.musicianType,
      pickedPhoto: pickedPhoto ?? this.pickedPhoto,
      status: status ?? this.status,
      picker: picker,
      formKey: formKey,
    );
  }
  
  @override
  List<FormzInput<String, Object>> get inputs => [
    username,
    artistName,
    bio,
  ];
}
