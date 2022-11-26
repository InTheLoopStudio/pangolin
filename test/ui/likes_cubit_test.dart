import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/views/likes/likes_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'likes_cubit_test.mocks.dart';

@GenerateMocks([DatabaseRepository])
void main() {
  final loop = Loop.empty();

  group('there are no likers', () {
    final databaseRepository = MockDatabaseRepository();
    when(databaseRepository.getLikes(loop.id)).thenAnswer((_) async => []);

    blocTest<LikesCubit, LikesState>(
      'likes should emit empty array if db repo has no likers',
      build: () => LikesCubit(
        loop: loop,
        databaseRepository: databaseRepository,
      ),
      act: (LikesCubit bloc) => bloc.initLikes(),
      expect: () => [const LikesState()],
    );
  });

  group('there are likers', () {
    final databaseRepository = MockDatabaseRepository();
    when(databaseRepository.getLikes(loop.id))
        .thenAnswer((_) async => [UserModel.empty()]);

    blocTest<LikesCubit, LikesState>(
      'likes should emit array of likers if db repo has likers',
      build: () => LikesCubit(
        loop: loop,
        databaseRepository: databaseRepository,
      ),
      act: (LikesCubit bloc) => bloc.initLikes(),
      expect: () => [
        LikesState(likes: [UserModel.empty()])
      ],
    );
  });
}
