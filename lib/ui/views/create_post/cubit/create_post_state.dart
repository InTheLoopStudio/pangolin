part of 'create_post_cubit.dart';

class CreatePostState extends Equatable with FormzMixin {
  const CreatePostState({
    this.title = const PostTitle.pure(),
    this.description = const PostDescription.pure(),
    this.status = FormzSubmissionStatus.initial,
  });

  final PostTitle title;
  final PostDescription description;
  final FormzSubmissionStatus status;

  @override
  List<Object> get props => [
        title,
        description,
        status,
      ];

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [
        title,
        description,
      ];

  CreatePostState copyWith({
    PostTitle? title,
    PostDescription? description,
    FormzSubmissionStatus? status,
  }) {
    return CreatePostState(
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }
}
