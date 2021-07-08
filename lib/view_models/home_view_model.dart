import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:sas_application/models/firebase_model.dart';
import 'package:sas_application/views/screens/log_in.dart';


class HomeViewModel extends FireBaseModel {
  final FireBaseModel _fireBaseModel = new FireBaseModel();

  Future<void> signOutAnonymously(BuildContext context) async {
    try {
      await _fireBaseModel.auth.signOut();
      showPlatformDialog(
          context: context,
          builder: (context) =>
              FutureProgressDialog(getFuture(),
                  message: Text('Signing Out.....')));
      Timer(Duration(seconds: 3), () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (builder) => LoginPage()),
                (Route<dynamic> route) => false);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future getFuture() {
    return Future(() async {
      await Future.delayed(Duration(seconds: 5));
      return 'Hello, Future Progress Dialog!';
    });
  }
}