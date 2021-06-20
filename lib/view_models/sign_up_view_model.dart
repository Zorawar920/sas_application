import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sas_application/models/firebase_model.dart';
import 'package:sas_application/views/screens/log_in.dart';

class SignUpViewModel extends FireBaseModel {
  final FireBaseModel _fireBaseModel = new FireBaseModel();

  Future<void> createUserWithCredentials(
      emailAddress, password, BuildContext context) async {
    try {
      _fireBaseModel.setBusy(true);
      String _email = emailAddress.text.trim();
      String _password = password.text.trim();
      await _fireBaseModel.auth
          .createUserWithEmailAndPassword(_email, _password);
      _fireBaseModel.setBusy(false);
      Timer(Duration(seconds: 3), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (builder) => LoginPage()));
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("There's already an account with this email")));
          break;
        case "network-request-failed":
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Sign Up failed due to Network error")));
          break;
        case "invalid-email":
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Entered Email is invalid")));
          break;
        default:
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Sign Up failed")));
          break;
      }
      print(e.code);
    }
  }

  // Validation Functions of View Model
  String? validatePassword(passwordValue) {
    if (passwordValue.isEmpty) {
      return 'Please Enter Password ';
    } else if (passwordValue.length < 6) {
      return 'Password Should be atleast 6 characters long';
    } else if (passwordValue.length > 20) {
      return 'Password Should be less than 20 characters';
    }
  }

  String? validateConfirmPassword(oldPassValue, newPassValue) {
    if (oldPassValue.isEmpty) {
      return 'Please Enter Password Field First';
    } else if (oldPassValue != newPassValue) {
      return 'Password does not match';
    } else {
      return null;
    }
  }

  String? validateName(nameValue) {
    if (nameValue.isEmpty) {
      return 'Please Enter Your Name';
    } else if (nameValue.length >= 20) {
      return 'Name should be less than 20 Characters';
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
