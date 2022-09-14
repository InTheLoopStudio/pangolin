import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: <Color>[
              Color(0xff383838),
              Color(0xff000000),
            ],
          ),
        ),
        child: Align(
          alignment: const Alignment(0, -1 / 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/tapped_logo_reversed.png',
                    height: 60,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              SpinKitWave(
                color: Colors.white,
                size: 25.0,
                duration: const Duration(milliseconds: 1200),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
