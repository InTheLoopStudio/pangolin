import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/login/login_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/forms/email_text_field.dart';
import 'package:intheloopapp/ui/widgets/common/forms/password_text_field.dart';
import 'package:intheloopapp/ui/widgets/common/forms/username_text_field.dart';
import 'package:intheloopapp/ui/widgets/login_view/forgot_password_button.dart';
import 'package:intheloopapp/ui/widgets/login_view/login_button.dart';
import 'package:intheloopapp/ui/widgets/login_view/signup_button.dart';

class TraditionalLogin extends StatelessWidget {
  const TraditionalLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Column(
          children: [
            EmailTextField(
              onChanged: (input) =>
                  context.read<LoginCubit>().updateEmail(input ?? ''),
            ),
            const SizedBox(
              height: 10,
            ),
            PasswordTextField(
              onChanged: (input) =>
                  context.read<LoginCubit>().updatePassword(input ?? ''),
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SignUpButton(),
                LoginButton(),
              ],
            ),
            const ForgotPasswordButton(),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }
}
