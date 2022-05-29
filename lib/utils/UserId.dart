import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserId {
  String? userId;
  final storage = new FlutterSecureStorage();

  UserId._internal();

  static final UserId _instance = UserId._internal();

  factory UserId() {
    if (_instance.userId == null) {
      _instance.get();
    }
    return _instance;
  }

  Future<bool> get() {
    return storage.read(key: 'userId').then((value) {
      if (value == null) {
        this.userId = null;
        return false;
      } else {
        this.userId = value;
        return true;
      }
    }).catchError((onError) => false);
  }

  Future<bool> remove() {
    return storage.delete(key: 'userId').then(((value) {
      userId = null;
      return true;
    })).catchError((error) {
      return false;
    });
  }

  Future<bool> set(String userId) {
    return storage.write(key: 'userId', value: userId).then((value) {
      this.userId = userId;
      return true;
    }).catchError((onError) => false);
  }
}
