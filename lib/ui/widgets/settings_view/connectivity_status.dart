import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityStatus extends StatelessWidget {
  const ConnectivityStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {

        if (!snapshot.hasData) return const SizedBox.shrink();

        ConnectivityResult status = snapshot.data!;

        return status == ConnectivityResult.none ? Container(
                alignment: Alignment.center,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  border: Border.all(color: Colors.white),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset.zero,
                      blurRadius: 1.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                ),
                child: const Text(
                  "Offline",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              )
              : const SizedBox.shrink();
      }
    );
  }
}
