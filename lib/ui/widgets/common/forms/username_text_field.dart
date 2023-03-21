import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';

class UsernameTextField extends StatefulWidget {
  const UsernameTextField({
    required this.currentUserId,
    super.key,
    this.onSaved,
    this.onChanged,
    this.initialValue,
    this.validateUniqueness = true,
  });

  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String? initialValue;
  final String currentUserId;
  final bool validateUniqueness;

  @override
  State<UsernameTextField> createState() => _UsernameTextFieldState();
}

class _UsernameTextFieldState extends State<UsernameTextField> {
  bool _usernameTaken = false;

  String get _currentUserId => widget.currentUserId;
  bool get _validateUniqueness => widget.validateUniqueness;
  void Function(String?)? get _onSaved => widget.onSaved;
  void Function(String?)? get _onChanged => widget.onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-z0-9_\.\-\$]')),
      ],
      initialValue: widget.initialValue,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.person),
        labelText: 'Handle',
        hintText: 'tapped_network',
      ),
      validator: (input) {
        if (input!.trim().length < 2) {
          return 'please enter a valid handle';
        }

        if (_usernameTaken) {
          return 'handle already in use';
        }

        return null;
      },
      onSaved: (input) async {
        if (input == null || input.isEmpty) return;

        input = input.trim().toLowerCase();
        // DatabaseRepository databaseRepo =
        //     RepositoryProvider.of<DatabaseRepository>(context);
        // bool available =
        // await databaseRepo.checkUsernameAvailability(input, _currentUserId);
        // setState(() {
        //   _usernameTaken = !available;
        // });

        _onSaved?.call(input);
      },
      onChanged: (input) async {
        if (input.isEmpty) return;

        input = input.trim().toLowerCase();

        if (_validateUniqueness) {
          final databaseRepo =
              RepositoryProvider.of<DatabaseRepository>(context);
          final available = await databaseRepo.checkUsernameAvailability(
            input,
            _currentUserId,
          );
          setState(() {
            _usernameTaken = !available;
          });
        }

        _onChanged?.call(input);
      },
    );
  }
}
