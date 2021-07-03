import 'dart:async';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:sas_application/models/firebase_model.dart';
import 'package:flutter/material.dart';
import 'package:sas_application/models/user_model.dart';
//import 'package:flutter_otp/flutter_otp.dart';
import 'package:sas_application/views/screens/log_in.dart';

class UserScreenViewModel extends FireBaseModel {
  final FireBaseModel _fireBaseModel = new FireBaseModel();

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

  Future<void> updateUser(firstName, lastName, phoneNumber, email, gender,
      BuildContext context) async {
    try {
      _fireBaseModel.setBusy(true);
      String _phoneNumber = phoneNumber.text.trim();
      String _gender = gender.text.trim();
      String _firstname = firstName.text.trim();
      String _lastname = lastName.text.trim();
      String _email = email.text.trim();
      String name = _firstname + " " + _lastname;
      UserModel userModel = new UserModel(
          userId: _fireBaseModel.auth.currentUser!.uid,
          fullName: name,
          emailAddress: _email,
          phoneNumber: _phoneNumber,
          gender: _gender);
      await _fireBaseModel.firebaseDbService.updateUserData(userModel);
      _fireBaseModel.setBusy(false);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> verifyPhoneNumber(
      TextEditingController phoneController, BuildContext context) async {
    try {
      _fireBaseModel.setBusy(true);
      await _fireBaseModel.auth.VerifyNumber(phoneController, context);
      _fireBaseModel.setBusy(false);
    } catch (e) {
      print(e.toString());
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
    const pattern = r'^\+(?:[0-9] ?){6,14}[0-9]$';
    final regExp = RegExp(pattern);
    if (phoneValue.isEmpty) {
      return 'Please Enter Phone Number';
    } else if (!regExp.hasMatch(phoneValue)) {
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
