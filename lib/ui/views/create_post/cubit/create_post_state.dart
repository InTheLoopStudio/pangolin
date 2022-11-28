part of 'create_post_cubit.dart';

class CreatePostState extends Equatable {
  const CreatePostState({
    this.title = '',
    this.description = '',
  });

  final String title;
  final String description;

  @override
  List<Object> get props => [
        title,
        description,
      ];

  CreatePostState copyWith({
    String? title,
    String? description,
  }) {
    return CreatePostState(
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}
