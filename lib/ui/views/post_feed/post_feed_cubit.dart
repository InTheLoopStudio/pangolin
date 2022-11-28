import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'post_feed_state.dart';

class PostFeedCubit extends Cubit<PostFeedState> {
  PostFeedCubit() : super(PostFeedInitial());
}
