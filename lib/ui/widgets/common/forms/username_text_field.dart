import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/themes.dart';

class UsernameTextField extends StatefulWidget {
  const UsernameTextField({
    Key? key,
    this.onSaved,
    this.onChanged,
    this.initialValue,
    required this.onCheckUsername,
    required this.currentUserId,
  }) : super(key: key);

  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final Future<UserModel?> Function(String?) onCheckUsername;
  final String? initialValue;
  final String currentUserId;

  @override
  State<UsernameTextField> createState() => _UsernameTextFieldState();
}

class _UsernameTextFieldState extends State<UsernameTextField> {
  bool _usernameTaken = false;

  String get _currentUserId => widget.currentUserId;
  Future<UserModel?> Function(String?) get _onCheckUsername =>
      widget.onCheckUsername;
  void Function(String?)? get _onSaved => widget.onSaved;
  void Function(String?)? get _onChanged => widget.onChanged;

  Future<void> _checkUsername(String? input) async {
    UserModel? user = await _onCheckUsername(input);

    setState(() {
      _usernameTaken = (user != null && user.id != _currentUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"[a-z0-9_\.\-\$]")),
      ],
      initialValue: widget.initialValue,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        labelText: 'Artist Name',
        hintText: 'Artist Name',
      ),
      validator: (input) {
        if (input!.trim().length < 2) {
          return "please enter a valid name";
        }

        if (_usernameTaken) {
          return "username already in use";
        }

        return null;
      },
      onSaved: (input) {
        _checkUsername(input);
        if (_onSaved != null) {
          _onSaved!(input);
        }
      },
      onChanged: (input) {
        input = input.trim().toLowerCase();
        _checkUsername(input);
        if (_onChanged != null) {
          _onChanged!(input);
        }
      },
    );
  }
}
