import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/ui/views/messaging/new_chat/new_chat_cubit.dart';
import 'package:intheloopapp/ui/widgets/messaing_view/results_list.dart';
import 'package:intheloopapp/ui/widgets/messaing_view/search_bar.dart' as search;

class NewChatView extends StatelessWidget {
  const NewChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewChatCubit(
        searchRepository: context.read<SearchRepository>(),
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.5,
          title: const search.SearchBar(),
        ),
        body: const Center(
          child: ResultsList(),
        ),
      ),
    );
  }
}
