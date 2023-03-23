import 'package:flutter/cupertino.dart';

class ConnectBankButton extends StatelessWidget {
  const ConnectBankButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton.filled(
      child: const Text('Connect Bank Account'),
      onPressed: () {
        // create connected account

        // get the account by ID to see if it connected correctly
      },
    );
  }
}
