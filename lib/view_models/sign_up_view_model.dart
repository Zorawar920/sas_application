import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:sas_application/models/firebase_model.dart';
import 'package:sas_application/models/user_model.dart';
import 'package:sas_application/views/screens/log_in.dart';

class SignUpViewModel extends FireBaseModel {
  final FireBaseModel _fireBaseModel = new FireBaseModel();

  Future<void> createUserWithCredentials(
      emailAddress, password, firstName, lastName, BuildContext context) async {
    try {
      _fireBaseModel.setBusy(true);
      String _email = emailAddress.text.trim();
      String _password = password.text.trim();
      String _firstname = firstName.text.trim();
      String _lastname = lastName.text.trim();
      String name = _firstname + " " + _lastname;

      await _fireBaseModel.auth
          .createUserWithEmailAndPassword(_email, _password);

      UserModel userModel = new UserModel(
          userId: _fireBaseModel.auth.currentUser!.uid,
          fullName: name,
          emailAddress: _email);

      _fireBaseModel.firebaseDbService.addUserData(userModel);

      _fireBaseModel.setBusy(false);
      showPlatformDialog(
          context: context,
          builder: (context) {
            return BasicDialogAlert(
              title: Text("Email Verification Link"),
              content: Text(
                  "The verification link is sent to this mail-id : $_email"),
              actions: [
                BasicDialogAction(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) => LoginPage()));
                    },
                    title: Text("OK"))
              ],
            );
          });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          showPlatformDialog(
              context: context,
              builder: (context) {
                return BasicDialogAlert(
                  title: Text("E-mail Already In Use"),
                  content: Text("There's already an account with this email"),
                  actions: [
                    BasicDialogAction(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        title: Text("OK"))
                  ],
                );
              });
          break;
        case "network-request-failed":
          showPlatformDialog(
              context: context,
              builder: (context) {
                return BasicDialogAlert(
                  title: Text("Network Issue"),
                  content: Text("Sign up failed due to network error"),
                  actions: [
                    BasicDialogAction(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        title: Text("OK"))
                  ],
                );
              });
          break;
        case "invalid-email":
          showPlatformDialog(
              context: context,
              builder: (context) {
                return BasicDialogAlert(
                  title: Text("Invalid Email"),
                  content: Text(
                      "Entered Email is invalid. Please enter valid e-mail"),
                  actions: [
                    BasicDialogAction(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        title: Text("OK"))
                  ],
                );
              });
          break;
        default:
          showPlatformDialog(
              context: context,
              builder: (context) {
                return BasicDialogAlert(
                  title: Text("Sign Up Issue"),
                  content: Text("Issue while signing up the user."),
                  actions: [
                    BasicDialogAction(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        title: Text("OK"))
                  ],
                );
              });
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
