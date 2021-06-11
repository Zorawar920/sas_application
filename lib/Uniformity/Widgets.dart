import 'package:flutter/material.dart';
import './style.dart';
// ignore: unused_import

Widget buildSignInWithText() {
  return Column(
    children: <Widget>[
      Text(
        '- OR -',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
      SizedBox(height: 10.0),
      Text(
        'Sign in with',
        style: labelStyle,
      ),
    ],
  );
}

Widget buildAppScreenLogo() {
  return Container(
      child: Image.asset(
    'assets/logos/initial_app_screen_logo_1.png',
    height: 220.0,
    width: 220.0,
  ));
}

Widget buildSocialButton(AssetImage logo) {
  return GestureDetector(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    ),
  );
}

Widget buildSocialBtnRow() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 30.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[],
    ),
  );
}

Widget ForgotPasswordBtn() {
  return Container(
      //padding: EdgeInsets.symmetric(vertical: 5.0),
      child: TextButton(
    onPressed: () {
      print('Forgot Password');
    },
    child: Text(
      'Forgot Password?',
      style: TextStyle(
        color: Colors.white,
        letterSpacing: 1.5,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans',
      ),
    ),
  ));
}
