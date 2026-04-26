// Package imports:
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:kht_gold/core/constants/storage_key.dart';

abstract class AuthLocalData {
  void saveAuth({required String accessToken, required DateTime expiresAt});
  String get accessToken;
  DateTime? get expiresAt;
  bool get hasValidSession;
  void clearAuth();
}

@LazySingleton(as: AuthLocalData)
class AuthLocalDataImpl extends AuthLocalData {
  final Box hiveBox = Hive.box(StorageKeys.authBox);

  void saveAuth({required String accessToken, required DateTime expiresAt}) {
    hiveBox.put(StorageKeys.accessToken, accessToken);
    hiveBox.put(StorageKeys.expiresAt, expiresAt.toUtc().toIso8601String());
  }

  String get accessToken {
    return hiveBox.get(StorageKeys.accessToken, defaultValue: '').toString();
  }

  DateTime? get expiresAt {
    return DateTime.tryParse(
      hiveBox.get(StorageKeys.expiresAt, defaultValue: '').toString(),
    );
  }

  bool get hasValidSession {
    final DateTime? expiry = expiresAt;
    return accessToken.isNotEmpty &&
        expiry != null &&
        expiry.toUtc().isAfter(DateTime.now().toUtc());
  }

  void clearAuth() {
    hiveBox.delete(StorageKeys.accessToken);
    hiveBox.delete(StorageKeys.expiresAt);
  }
}
