import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  CreatePostCubit() : super(const CreatePostState());

  void onTitleChange(String input) => emit(state.copyWith(title: input));
  void onDescriptionChange(String input) => emit(state.copyWith(title: input));

  Future<void> createPost() async {}
}
