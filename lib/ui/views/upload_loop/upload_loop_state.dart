part of 'upload_loop_cubit.dart';

@immutable
class UploadLoopState extends Equatable {
  UploadLoopState({
    this.pickedAudio,
    this.loopTitle = const LoopTitle.pure(),
    // this.selectedTags = const [],
    this.status = FormzStatus.pure,
    AudioController? audioController,
  }) {
    this.audioController = audioController ?? AudioController();
  }

  late final AudioController audioController;

  final File? pickedAudio;
  // final List<Tag> selectedTags;
  final LoopTitle loopTitle;
  final FormzStatus status;

  @override
  List<Object?> get props => [
        loopTitle,
        pickedAudio,
        audioController,
        // selectedTags,
        status,
      ];

  UploadLoopState copyWith({
    File? pickedAudio,
    // List<Tag>? selectedTags,
    LoopTitle? loopTitle,
    FormzStatus? status,
  }) {
    return UploadLoopState(
      pickedAudio: pickedAudio ?? this.pickedAudio,
      // selectedTags: selectedTags ?? this.selectedTags,
      loopTitle: loopTitle ?? this.loopTitle,
      audioController: this.audioController,
      status: status ?? this.status,
    );
  }
}
