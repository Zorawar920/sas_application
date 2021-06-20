import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sas_application/models/firebase_model.dart';
import 'package:sas_application/views/screens/log_in.dart';

class ForgotPasswordViewModel extends FireBaseModel {
  final FireBaseModel _fireBaseModel = new FireBaseModel();

  Future<void> sendResetPasswordMail(email, BuildContext context) async {
    try {
      _fireBaseModel.setBusy(true);
      var _ = await _fireBaseModel.auth
          .signInWithEmailAndPassword(email, 'password');
      await _fireBaseModel.auth.currentUser!.reload();
      _fireBaseModel.setBusy(false);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          final snackBar =
              SnackBar(content: Text('This Email is invalid: $email'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        case "wrong-password":
          final snackBar =
              SnackBar(content: Text('Reset Password Email is sent to $email'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          await _fireBaseModel.auth.forgotPasswordWithEmail(email);
          Navigator.push(
              context, MaterialPageRoute(builder: (builder) => LoginPage()));
          break;
        case "user-not-found":
          final snackBar = SnackBar(
              content: Text('This Email does not exist in system: $email'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
      }
    }
  }

  // Validation Functions for View Model
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
