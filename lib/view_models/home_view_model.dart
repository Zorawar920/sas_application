import 'dart:io';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sas_application/models/firebase_model.dart';
import 'package:sas_application/models/sentiment_model.dart';
import 'package:sms/sms.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeViewModel extends FireBaseModel {
  final FireBaseModel _fireBaseModel = new FireBaseModel();
  final SpeechToText speech = SpeechToText();
  var resultListened;
  final sentiment = Sentiment();
  String text = "";

  Future<List> getRecipientsList() async {
    var snapshots = await _fireBaseModel.firebaseDbService.instance
        .collection('users')
        .doc(_fireBaseModel.auth.currentUser!.uid)
        .collection("emergencyContacts")
        .get();
    final allData = snapshots.docs.map((doc) => doc.data()).toList();
    return allData;
  }

  void _sendSMS(
      {required String message, required List<String> recipents}) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  Future getFuture() {
    return Future(() async {
      await Future.delayed(Duration(seconds: 5));
      return 'Hello, Future Progress Dialog!';
    });
  }

  Future<void> map(String dropDownValue) async {
    Geolocator.checkPermission();
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
    var list = await getRecipientsList();
    for (var map in list) {
      var address = map["emergencyContactNumber"];
      String url =
          "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";
      String encodedURl = Uri.encodeFull(url) + " " + dropDownValue;
      if (Platform.isIOS) {
        List<String> recipents = [];
        recipents.add(address);
        _sendSMS(message: encodedURl, recipents: recipents);
      } else {
        SmsSender sender = new SmsSender();
        sender.sendSms(new SmsMessage(address, encodedURl));
      }
    }
  }

  Future<void> startRecord(BuildContext context) async {
    bool available = await speech.initialize(
        onStatus: statusListener, onError: errorListener);
    if (available) {
      speech.listen(
          onResult: resultListener,
          listenFor: Duration(seconds: 30),
          pauseFor: Duration(seconds: 5),
          listenMode: ListenMode.confirmation,
          cancelOnError: true);
    } else {
      showPlatformDialog(
          context: context,
          builder: (context) {
            return BasicDialogAlert(
              title: Text("Permission Issue"),
              content: Text(
                  "The user has denied the permission for speech recognition"),
              actions: [
                BasicDialogAction(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    title: Text("OK"))
              ],
            );
          });
    }
  }

  Future<void> stopRecord() async {
    speech.stop();
  }

  void errorListener(SpeechRecognitionError errorNotification) {
    var lastError =
        '${errorNotification.errorMsg} - ${errorNotification.permanent}';
    print(lastError);
  }

  void statusListener(String status) {}

  void resultListener(SpeechRecognitionResult result) {
    text = '${result.recognizedWords}';
    if (speech.isNotListening) {
      var languageCode = ui.window.locale.languageCode;
      var result = sentiment.analysis(text, languageCode: languageCode);
      if (result.isNotEmpty) {
        var score = result['score'];
        if (score < 0) {
          map(text);
        }
      }
    }
  }
}
