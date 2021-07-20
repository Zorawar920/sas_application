import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:sas_application/models/firebase_model.dart';
import 'package:flutter/material.dart';
import 'package:sas_application/models/user_model.dart';
import 'package:sas_application/singleton_instance.dart';
import 'package:sas_application/views/screens/emergency_contact.dart';
import 'package:sas_application/views/screens/log_in.dart';

class UserScreenViewModel extends FireBaseModel {
  final FireBaseModel _fireBaseModel = new FireBaseModel();
  User? get currentUser => FirebaseAuth.instance.currentUser;

  final UserModel userModel = singletonInstance<UserModel>();

  Future getFuture() {
    return Future(() async {
      await Future.delayed(Duration(seconds: 5));
      return 'Hello, Future Progress Dialog!';
    });
  }

  Future<void> signOutAnonymously(BuildContext context) async {
    try {
      await _fireBaseModel.auth.signOut();
      showPlatformDialog(
          context: context,
          builder: (context) => FutureProgressDialog(getFuture(),
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

  Future<void> updateUser(phoneNumber, gender, BuildContext context) async {
    try {
      _fireBaseModel.setBusy(true);
      String _phoneNumber = phoneNumber;
      userModel.gender = gender;
      userModel.phoneNumber = _phoneNumber;
      await _fireBaseModel.firebaseDbService.updateUserData(
          _fireBaseModel.auth.currentUser!.uid, _phoneNumber, gender);
      _fireBaseModel.setBusy(false);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (builder) => EmergencyContactScreen()),
          (Route<dynamic> route) => false);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> verifyPhoneNumber(String phone, BuildContext context) async {
    try {
      _fireBaseModel.setBusy(true);
      await _fireBaseModel.auth.verifyNumber(
          phone, context, "", _fireBaseModel.auth.currentUser!.uid);
      _fireBaseModel.setBusy(false);
    } catch (e) {
      print(e.toString());
    }
  }

  String? validateCountryCode(value) {
    if (value == null) {
      return 'Please enter the country code';
    }
  }

  String? validateName(nameValue) {
    if (nameValue.isEmpty) {
      return 'Please Enter Your Name';
    } else if (nameValue.length >= 20) {
      return 'Name should be less than 20 Characters';
    }
  }

  String? validatePhone(phoneValue) {
    if (phoneValue.isEmpty) {
      return 'Please Enter Phone Number';
    } else if (phoneValue.length != 10) {
      return 'Please Enter Valid Phone Number';
    }
  }

  String? validateGender(gender) {
    if (gender.isEmpty) {
      return 'Please Enter Your Gender';
    }
  }

  String? validateAge(age) {
    if (age.isEmpty) {
      return 'Please Enter Your Age';
    } else if (int.parse(age) < 12 || int.parse(age) > 80) {
      return 'Enter valid age';
    }
  }

  String? validateEmail(emailValue) {
    RegExp regex = RegExp(r'\w+@\w+\.\w+');
    if (emailValue.isEmpty) {
      return 'Please Enter Email';
    } else if (!regex.hasMatch(emailValue)) {
      return 'Please Enter a Valid Email';
    } else if (emailValue.length > 30) {
      return 'Email should be less than 30 Characters';
    }
  }
}
