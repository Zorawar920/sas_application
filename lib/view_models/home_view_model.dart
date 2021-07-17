import 'dart:io';
import 'dart:async';


import 'package:flutter_sms/flutter_sms.dart';
import 'package:geolocator/geolocator.dart';
import 'package:record/record.dart';
import 'package:sas_application/models/firebase_model.dart';
import 'package:sas_application/view_models/emergency_contact_view_model.dart';
import 'package:sms/sms.dart';


class HomeViewModel extends FireBaseModel {
  final FireBaseModel _fireBaseModel = new FireBaseModel();
  final _audioRecorder = Record();

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

  Future getFuture() {
    return Future(() async {
      await Future.delayed(Duration(seconds: 5));
      return 'Hello, Future Progress Dialog!';
    });
  }

  Future<void> startRecord() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start(
            encoder: AudioEncoder.AAC, bitRate: 128000, samplingRate: 44100);
        bool isRecording = await _audioRecorder.isRecording();
        if (isRecording) {
          print("Audio Recording Started");
        }
      }
    } catch (e) {
      print("Error while recording $e");
    }
  }

  Future<void> stopRecord() async {
    final path = await _audioRecorder.stop();
    print("Path of recorded audio    $path");
  }

}


