import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:sas_application/models/firebase_model.dart';
import 'package:sas_application/view_models/emergency_contact_view_model.dart';
import 'package:sas_application/views/screens/emergency_contact.dart';
import 'package:sas_application/views/screens/log_in.dart';
import 'package:sms/sms.dart';


class HomeViewModel extends FireBaseModel {
  final FireBaseModel _fireBaseModel = new FireBaseModel();

  final EmergencyContactViewModel es = new EmergencyContactViewModel();

  getContactList() async {
    return es.getList();
  }

  void _sendSMS(
      {required String message, required List<String> recipents}) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  Future<void> map() async {
    Geolocator.checkPermission();
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
    var list = await getContactList();
    for (var map in list) {
      var address = map["emergency-contact-number"];
      String url =
          "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";
      String encodedURl = Uri.encodeFull(url) + " HELP...!!!";
      if (Platform.isIOS) {
        List<String> recipents = [];
        recipents.add(address);
        _sendSMS(message: encodedURl, recipents: recipents);
      }
      else{
        SmsSender sender = new SmsSender();
        sender.sendSms(new SmsMessage(address, encodedURl));
      }
    }
  }
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


