import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';

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
    return BlocSelector<AuthenticationBloc, AuthenticationState, Authenticated>(
      selector: (state) => state as Authenticated,
      builder: (context, state) {
        final currentUser = state.currentUser;
        return TextFormField(
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-z0-9_\.\-\$]')),
          ],
          initialValue: widget.initialValue,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.person),
            labelText: 'Recipient',
            hintText: "who's getting the badge?",
          ),
          validator: (input) {
            if (input!.trim().length < 2) {
              return 'please enter a valid name';
            }

            if (!_usernameExists) {
              return 'user does not exist';
            }

            if (input == currentUser.username) {
              return 'cannot send badges to yourself';
            }

            return null;
          },
          onSaved: (input) async {
            if (input == null || input.isEmpty) return;

            final databaseRepo =
                RepositoryProvider.of<DatabaseRepository>(context);
            final receiver = await databaseRepo.getUserByUsername(input);
            setState(() {
              _usernameExists = !(receiver == null);
            });

            widget.onSaved?.call(input);
          },
          onChanged: (input) async {
            if (input.isEmpty) return;

            input = input.trim().toLowerCase();

            final databaseRepo =
                RepositoryProvider.of<DatabaseRepository>(context);
            final receiver = await databaseRepo.getUserByUsername(input);
            setState(() {
              _usernameExists = !(receiver == null);
            });

            widget.onChanged?.call(input);
          },
        );
      },
    );
  }
}
