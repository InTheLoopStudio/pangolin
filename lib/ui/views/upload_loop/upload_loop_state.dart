part of 'upload_loop_cubit.dart';

@immutable
class UploadLoopState extends Equatable with FormzMixin {
  UploadLoopState({
    this.audioController,
    this.pickedAudio,
    this.loopTitle = const LoopTitle.pure(),
    // this.selectedTags = const [],
    this.status = FormzSubmissionStatus.initial,
  });

  final AudioController? audioController;

  final File? pickedAudio;
  // final List<Tag> selectedTags;
  final LoopTitle loopTitle;
  final FormzSubmissionStatus status;

  @override
  List<Object?> get props => [
        loopTitle,
        pickedAudio,
        audioController,
        // selectedTags,
        status,
      ];

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [
    loopTitle,
  ];

  UploadLoopState copyWith({
    File? pickedAudio,
    // List<Tag>? selectedTags,
    LoopTitle? loopTitle,
    AudioController? audioController,
    FormzSubmissionStatus? status,
  }) {
    return UploadLoopState(
      pickedAudio: pickedAudio ?? this.pickedAudio,
      // selectedTags: selectedTags ?? this.selectedTags,
      loopTitle: loopTitle ?? this.loopTitle,
      audioController: audioController ?? this.audioController,
      status: status ?? this.status,
    );
  }
}
