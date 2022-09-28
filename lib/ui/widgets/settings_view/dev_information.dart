import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DevInformation extends StatefulWidget {
  const DevInformation({Key? key}) : super(key: key);

  @override
  State<DevInformation> createState() => _DevInformationState();
}

class _DevInformationState extends State<DevInformation> {
  String _appName = '';
  String _version = '';
  String _buildNumber = '';

  Future<void> initPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appName = packageInfo.appName;
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  void initState() {
    initPackageInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/icon_1024.png',
          scale: 15,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_appName, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              'Version $_version+$_buildNumber',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const Text(
              'Copyright © Tapped 2022',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
