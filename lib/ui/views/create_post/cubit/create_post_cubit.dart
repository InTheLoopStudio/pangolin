import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/post.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/widgets/create_post_view/post_description.dart';
import 'package:intheloopapp/ui/widgets/create_post_view/post_title.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  CreatePostCubit({
    required this.currentUser,
    required this.databaseRepository,
    required this.navigationBloc,
  }) : super(const CreatePostState());

  final UserModel currentUser;
  final DatabaseRepository databaseRepository;
  final NavigationBloc navigationBloc;

  void onTitleChange(String input) {
    final title = PostTitle.dirty(input);
    emit(
      state.copyWith(title: title),
    );
  }

  void onDescriptionChange(String input) {
    final description = PostDescription.dirty(input);
    emit(
      state.copyWith(
        description: description,
      ),
    );
  }

  Future<void> createPost() async {
    try {
      if (state.status.isInProgress) return;

      if (state.isValid) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.inProgress,
          ),
        );

        final post = Post.empty().copyWith(
          title: state.title.value,
          description: state.description.value,
          userId: currentUser.id,
          // tags: state.selectedTags.map((tag) => tag.value).toList(),
        );

        await databaseRepository.addPost(post);

        emit(
          state.copyWith(
            title: const PostTitle.pure(),
            description: const PostDescription.pure(),
            status: FormzSubmissionStatus.success,
          ),
        );

        navigationBloc.add(const Pop());
      } else {
        navigationBloc.add(const Pop());
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
        ),
      );
      navigationBloc.add(const Pop());
    }
  }
}
