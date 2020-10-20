import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static final _storage = FlutterSecureStorage();

  Future<dynamic> readAll() async {
    return _storage.readAll();
  }

  Future<String> read(String key) async {
    print(key);
    var a = _storage.read(key: key);
    print(a);
    return a;
  }

  void deleteAll() async {
    await _storage.deleteAll();
  }

  void addNewItem(String key, String value) async {
    await _storage.write(key: key, value: value);
  }
}
