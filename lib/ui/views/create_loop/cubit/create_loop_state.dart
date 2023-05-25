part of 'create_loop_cubit.dart';

class CreateLoopState extends Equatable with FormzMixin {
  const CreateLoopState({
    this.title = const LoopTitle.pure(),
    this.description = const LoopDescription.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isOpportunity = false,
    this.pickedAudio,
    this.pickedImage,
    this.audioController,
  });

  final LoopTitle title;
  final LoopDescription description;
  final FormzSubmissionStatus status;
  final bool isOpportunity;

  final File? pickedAudio;
  final File? pickedImage;
  final AudioController? audioController;

  @override
  List<Object?> get props => [
        title,
        description,
        status,
        isOpportunity,
        pickedAudio,
        pickedImage,
        audioController,
      ];

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [
        title,
        description,
      ];

  CreateLoopState copyWith({
    required File? pickedAudio,
    required File? pickedImage,
    bool? isOpportunity,
    LoopTitle? title,
    LoopDescription? description,
    FormzSubmissionStatus? status,
    AudioController? audioController,
  }) {
    return CreateLoopState(
      pickedAudio: pickedAudio,
      pickedImage: pickedImage,
      isOpportunity: isOpportunity ?? this.isOpportunity,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      audioController: audioController ?? this.audioController,
    );
  }
}
