import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:sas_application/external_services/contact_services.dart';
import 'package:sas_application/firebase_services/auth.dart';
import 'package:sas_application/firebase_services/firebase_db.dart';
import 'package:sas_application/models/user_model.dart';
import 'package:sas_application/singleton_instance.dart';

class FireBaseModel extends ChangeNotifier {
  bool _busy = false;
  bool get busy => _busy;

  final Auth auth = singletonInstance<Auth>();
  final Services services = singletonInstance<Services>();
  final FirebaseDbService firebaseDbService =
      singletonInstance<FirebaseDbService>();

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}
