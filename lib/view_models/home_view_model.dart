import 'package:flutter/material.dart';
import 'package:sas_application/models/firebase_model.dart';
import 'package:sas_application/views/screens/log_in.dart';

class HomeViewModel extends FireBaseModel {
  final FireBaseModel _fireBaseModel = new FireBaseModel();

  Future<void> signOutAnonymously(BuildContext context) async {
    try {
      await _fireBaseModel.auth.signOut();
    } catch (e) {
      print(e.toString());
    }
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (builder) => LoginPage()),
        (Route<dynamic> route) => false);
  }
}
