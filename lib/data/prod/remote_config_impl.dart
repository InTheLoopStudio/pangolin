import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:intheloopapp/data/remote_config_repository.dart';

FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

class RemoteConfigImpl implements RemoteConfigRepository {
  Future<bool> fetchAndActivate() async {
    bool updated = await _remoteConfig.fetchAndActivate();
    return updated;
  }

  Future<bool> getDownForMaintenanceStatus() async {
    return _remoteConfig.getBool('down_for_maintenance');
  }
}
