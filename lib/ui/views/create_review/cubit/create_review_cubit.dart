import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_review_state.dart';

class CreateReviewCubit extends Cubit<CreateReviewState> {
  CreateReviewCubit() : super(CreateReviewInitial());
}
