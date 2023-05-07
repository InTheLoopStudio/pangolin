import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logging/logging.dart';

final logger = AppLogger();

class AppLogger {
  AppLogger() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print(
        '${record.level.name}: ${record.time}: ${userId ?? "<NO UID>"}: ${record.message}',
      );
    });
  }

  final logger = Logger('Tapped');
  String? userId;

  void setUserIdentifier(String? userId) {
    this.userId = userId;
    FirebaseCrashlytics.instance.setUserIdentifier(userId ?? '');
  }

  void debug(String message) {
    logger.fine(message);
    FirebaseCrashlytics.instance.log(message);
  }

  void info(String message) {
    logger.info(message);
    FirebaseCrashlytics.instance.log(message);
  }

  void warning(String message) {
    logger.warning(message);
    FirebaseCrashlytics.instance.log(message);
  }

  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    bool fatal = false,
  }) {
    logger.severe(message, error, stackTrace);
    FirebaseCrashlytics.instance.log(message);
    FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: fatal);
  }
}
