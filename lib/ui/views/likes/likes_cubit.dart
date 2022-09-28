import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'likes_state.dart';

class LikesCubit extends Cubit<LikesState> {
  LikesCubit({
    required this.loop,
    required this.databaseRepository,
  }) : super(const LikesState());

  final Loop loop;
  final DatabaseRepository databaseRepository;

  Future<void> initLikes() async {
    final userLikes = await databaseRepository.getLikes(loop);

    emit(state.copyWith(likes: userLikes));
  }
}
