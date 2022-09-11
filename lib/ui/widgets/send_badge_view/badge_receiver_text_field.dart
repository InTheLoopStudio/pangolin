import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

class BadgeReceiverTextField extends StatefulWidget {
  const BadgeReceiverTextField({
    Key? key,
    this.onSaved,
    this.onChanged,
    this.initialValue,
  }) : super(key: key);

  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String? initialValue;

  @override
  State<BadgeReceiverTextField> createState() => _BadgeReceiverTextFieldState();
}

class _BadgeReceiverTextFieldState extends State<BadgeReceiverTextField> {
  bool _usernameExists = false;

  @override
  Widget build(BuildContext context) {
    DatabaseRepository databaseRepository = context.read<DatabaseRepository>();
    return BlocSelector<AuthenticationBloc, AuthenticationState, Authenticated>(
      selector: (state) => state as Authenticated,
      builder: (context, state) {
        UserModel currentUser = state.currentUser;
        return TextFormField(
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r"[a-z0-9_\.\-\$]")),
          ],
          initialValue: widget.initialValue,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            labelText: 'Recipient',
            hintText: "who's getting the badge?",
          ),
          validator: (input) {
            if (input!.trim().length < 2) {
              return "please enter a valid name";
            }

            if (!_usernameExists) {
              return "user does not exist";
            }

            if (input == currentUser.username) {
              return "cannot send badges to yourself";
            }

            return null;
          },
          onSaved: (input) async {
            if (input == null || input.isEmpty) return;

            DatabaseRepository databaseRepo =
                RepositoryProvider.of<DatabaseRepository>(context);
            UserModel? receiver = await databaseRepo.getUserByUsername(input);
            setState(() {
              _usernameExists = receiver == null ? false : true;
            });

            if (widget.onSaved != null) {
              widget.onSaved!(input);
            }
          },
          onChanged: (input) async {
            if (input.isEmpty) return;

            input = input.trim().toLowerCase();

            DatabaseRepository databaseRepo =
                RepositoryProvider.of<DatabaseRepository>(context);
            UserModel? receiver = await databaseRepo.getUserByUsername(input);
            setState(() {
              _usernameExists = receiver == null ? false : true;
            });

            if (widget.onChanged != null) {
              widget.onChanged!(input);
            }
          },
        );
      },
    );
  }
}
