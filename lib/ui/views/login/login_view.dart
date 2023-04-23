import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/login/login_cubit.dart';
import 'package:intheloopapp/ui/widgets/login_view/login_form.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocProvider(
        create: (context) => LoginCubit(
          authRepository: context.read<AuthRepository>(),
          navigationBloc: context.read<NavigationBloc>(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoginForm(
              authenticationBloc: context.read<AuthenticationBloc>(),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: const Text(
                    'Privacy Policy',
                    style: TextStyle(
                      color: tappedAccent,
                    ),
                  ),
                  onPressed: () => launchUrl(
                    Uri(
                      scheme: 'https',
                      path: 'tapped.jonaylor.xyz/privacy',
                    ),
                  ),
                ),
                TextButton(
                  child: const Text(
                    'Terms of Service',
                    style: TextStyle(
                      color: tappedAccent,
                    ),
                  ),
                  onPressed: () => launchUrl(
                    Uri(
                      scheme: 'https',
                      path: 'intheloopstudio.com/terms',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
