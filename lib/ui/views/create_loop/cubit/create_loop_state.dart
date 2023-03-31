part of 'create_loop_cubit.dart';

class CreateLoopState extends Equatable with FormzMixin {
  const CreateLoopState({
    this.title = const LoopTitle.pure(),
    this.description = const LoopDescription.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.pickedAudio,
    this.audioController,
  });

  final LoopTitle title;
  final LoopDescription description;
  final FormzSubmissionStatus status;
  
  final File? pickedAudio;
  final AudioController? audioController;

  @override
  List<Object?> get props => [
        title,
        description,
        status,
        pickedAudio,
        audioController,
      ];

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [
        title,
        description,
      ];

  CreateLoopState copyWith({
    LoopTitle? title,
    LoopDescription? description,
    FormzSubmissionStatus? status,
    File? pickedAudio,
    AudioController? audioController,
  }) {
    return CreateLoopState(
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      pickedAudio: pickedAudio ?? this.pickedAudio,
      audioController: audioController ?? this.audioController,
    );
  }
}
