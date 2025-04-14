import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class SecureStorageRepository {
  static const _userIdKey = 'user_id';
  static final _storage = FlutterSecureStorage();

  static Future<String> getOrCreateUserId() async {
    String? userId = await _storage.read(key: _userIdKey);

    if (userId == null) {
      userId = const Uuid().v4();
      await _storage.write(key: _userIdKey, value: userId);
    }

    return userId;
  }
}