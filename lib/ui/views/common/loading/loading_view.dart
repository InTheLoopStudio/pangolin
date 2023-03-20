import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Align(
        alignment: const Alignment(0, -1 / 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SpinKitWave(
              color: Colors.white,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }
}
