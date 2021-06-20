import 'package:flutter/cupertino.dart';
import 'package:sas_application/firebase_services/auth.dart';
import 'package:sas_application/singleton_instance.dart';

class FireBaseModel extends ChangeNotifier {
  bool _busy = false;
  bool get busy => _busy;

  final Auth auth = singletonInstance<Auth>();

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}
