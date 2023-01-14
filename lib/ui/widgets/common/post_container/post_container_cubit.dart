
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'post_container_state.dart';

class PostContainerCubit extends Cubit<PostContainerState> {
  PostContainerCubit() : super(PostContainerState());
}
