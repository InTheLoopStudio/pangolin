import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/ui/views/login/login_cubit.dart';
import 'package:intheloopapp/ui/widgets/login_view/login_form.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginCubit(context.read<AuthRepository>()),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: <Color>[
                Color(0xff000000),
                Color(0xff383838),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoginForm(
                authenticationBloc: context.read<AuthenticationBloc>(),
              ),
              const SizedBox(height: 30),
              TextButton(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Privacy Policy',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      FontAwesomeIcons.upRightFromSquare,
                      color: Colors.white,
                      size: 15,
                    ),
                  ],
                ),
                onPressed: () => launchUrl(
                  Uri(
                    scheme: 'https',
                    path: 'intheloopstudio.com/privacy',
                  ),
                ),
              ),
              TextButton(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Terms of Service',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      FontAwesomeIcons.upRightFromSquare,
                      color: Colors.white,
                      size: 15,
                    ),
                  ],
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
        ),
      ),
    );
  }
}
