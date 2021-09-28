part of 'likes_cubit.dart';

class LikesState extends Equatable {
  const LikesState({
    this.likes = const [],
  });

  final List<UserModel> likes;

  @override
  List<Object> get props => [likes];

  LikesState copyWith({
    List<UserModel>? likes,
  }) {
    return LikesState(
      likes: likes ?? this.likes,
    );
  }
}
