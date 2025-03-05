import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HideBalanceProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  bool _hideBalance = false;

  bool get hideBalance => _hideBalance;

  HideBalanceProvider() {
    loadPreference();
  }

  Future<void> loadPreference() async {
    String? hideBalanceValue = await _secureStorage.read(key: 'hideBalance');
    _hideBalance = hideBalanceValue == 'true';

    notifyListeners();
  }

  Future<void> setHideBalance(bool value) async {
    _hideBalance = value;
    await _secureStorage.write(key: 'hideBalance', value: value.toString());
    notifyListeners();
  }
}
