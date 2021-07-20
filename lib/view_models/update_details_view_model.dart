import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sas_application/models/firebase_model.dart';
import 'package:sas_application/view_models/user_screen_view_model.dart';
import 'package:sas_application/views/screens/user_profile.dart';

class UpdateDetailsViewModel extends FireBaseModel {
  final UserScreenViewModel _userScreenViewModel = new UserScreenViewModel();
  final FireBaseModel _fireBaseModel = new FireBaseModel();
  var codeFlag;

  Future<List> getInitialDetails()async{
    List userDetails = [];
    var details = await _fireBaseModel.firebaseDbService.instance
        .collection("users")
        .doc(_fireBaseModel.auth.currentUser!.uid)
        .get();
    var data =details.data();
    userDetails.add({
      'Name': data!["full_name"],
      'Phone': data['phone_number'],
      'Email': data['e-mail id'],
      'Gender': data['gender']
    });
    return userDetails;
  }


  Future<void> updateUser(details, BuildContext context) async {

    String email = _fireBaseModel.auth.currentUser!.email.toString();
    try {
      _fireBaseModel.setBusy(true);
      _userScreenViewModel.userModel.userId =
          _fireBaseModel.auth.currentUser!.uid;
      _userScreenViewModel.userModel.fullName = details[0];
      _userScreenViewModel.userModel.emailAddress = email;
      _userScreenViewModel.userModel.gender = details[2];
      _userScreenViewModel.userModel.phoneNumber = details[1];
      email = details[1];
      await _fireBaseModel.firebaseDbService
          .updateUserData(_userScreenViewModel.userModel, details);
      _fireBaseModel.setBusy(false);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (builder) => UserProfile()),
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

  Future getFuture() {
    return Future(() async {
      await Future.delayed(Duration(seconds: 5));
      return 'Hello, Future Progress Dialog!';
    });
  }
}