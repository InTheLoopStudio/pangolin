part of 'create_post_cubit.dart';

class CreatePostState extends Equatable {
  const CreatePostState({
    this.title = const PostTitle.pure(),
    this.description = const PostDescription.pure(),
    this.status = FormzStatus.pure,
  });

  final PostTitle title;
  final PostDescription description;
  final FormzStatus status;

  @override
  List<Object> get props => [
        title,
        description,
        status,
      ];

  CreatePostState copyWith({
    PostTitle? title,
    PostDescription? description,
    FormzStatus? status,
  }) {
    return CreatePostState(
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }
}
